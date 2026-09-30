using FluentValidation;
using FluentValidation.Results;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;
using Sonorus.Chat.Application.Commands.AddMessageToChat;
using Sonorus.Chat.Application.Commands.RegisterConnectionOfUserId;
using Sonorus.Chat.Application.Commands.UnregisterConnectionOfUserId;
using Sonorus.Chat.Application.ViewModels;
using Sonorus.SharedKernel;

namespace Sonorus.Chat.API.Hubs;

[Authorize]
public class ChatHub(IMediator mediator, IValidator<AddMessageToChatCommand> validator) : Hub {
    private readonly IMediator _mediator = mediator;
    private readonly IValidator<AddMessageToChatCommand> _validator = validator;

    public override async Task OnConnectedAsync() {
        RegisterConnectionOfUserIdCommand registerConnectionOfUserIdCommand = new(Context.User!.UserId(), Context.ConnectionId);
        await _mediator.Send(registerConnectionOfUserIdCommand);
    }

    public override async Task OnDisconnectedAsync(Exception? exception) {
        UnregisterConnectionOfUserIdCommand unRegisterConnectionOfUserIdCommand = new(Context.User!.UserId());
        await _mediator.Send(unRegisterConnectionOfUserIdCommand);
    }

    public async Task SendMessage(string payload) {
        AddMessageToChatInputModel? inputModel = JsonConvert.DeserializeObject<AddMessageToChatInputModel>(payload);

        if (inputModel is null) {
            await Clients.Caller.SendAsync("ErrorSendingMessage", new ErrorSendingMessageViewModel(default, [ "Dados de entrada inválido!" ]));
            return;
        }

        AddMessageToChatCommand addMessageToChatCommand = new(Context.User!.UserId(), inputModel);
        ValidationResult validationResult = _validator.Validate(addMessageToChatCommand);

        if (!validationResult.IsValid) {
            await Clients.Caller.SendAsync("ErrorSendingMessage", new ErrorSendingMessageViewModel(inputModel.MessageId, validationResult.Errors.Select(e => e.ErrorMessage)));
            return;
        }

        IEnumerable<string> connectionIds = await _mediator.Send(addMessageToChatCommand);
        await Clients.Clients(connectionIds).SendAsync("ReceiveMessage", new MessageViewModel(inputModel.Content, Context.User!.UserId(), addMessageToChatCommand.SentAt));
        await Clients.Caller.SendAsync("SentMessage", new SentMessageViewModel(addMessageToChatCommand.ChatId, inputModel.MessageId, addMessageToChatCommand.SentAt));
    }
}