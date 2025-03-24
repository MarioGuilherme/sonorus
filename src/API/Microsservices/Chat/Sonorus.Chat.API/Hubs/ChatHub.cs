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
        RegisterConnectionOfUserIdCommand registerConnectionOfUserIdCommand = new(this.Context.User!.UserId(), this.Context.ConnectionId);
        await this._mediator.Send(registerConnectionOfUserIdCommand);
    }

    public override async Task OnDisconnectedAsync(Exception? exception) {
        UnregisterConnectionOfUserIdCommand unRegisterConnectionOfUserIdCommand = new(this.Context.User!.UserId());
        await this._mediator.Send(unRegisterConnectionOfUserIdCommand);
    }

    public async Task SendMessage(string payload) {
        AddMessageToChatInputModel? inputModel = JsonConvert.DeserializeObject<AddMessageToChatInputModel>(payload);

        if (inputModel is null) {
            await this.Clients.Caller.SendAsync("ErrorSendingMessage", new ErrorSendingMessageViewModel(default, [ "Dados de entrada inválido!" ]));
            return;
        }

        AddMessageToChatCommand addMessageToChatCommand = new(this.Context.User!.UserId(), inputModel);
        ValidationResult validationResult = this._validator.Validate(addMessageToChatCommand);

        if (!validationResult.IsValid) {
            await this.Clients.Caller.SendAsync("ErrorSendingMessage", new ErrorSendingMessageViewModel(inputModel.MessageId, validationResult.Errors.Select(e => e.ErrorMessage)));
            return;
        }

        IEnumerable<string> connectionIds = await this._mediator.Send(addMessageToChatCommand);
        await this.Clients.Clients(connectionIds).SendAsync("ReceiveMessage", new MessageViewModel(inputModel.Content, this.Context.User!.UserId(), addMessageToChatCommand.SentAt));
        await this.Clients.Caller.SendAsync("SentMessage", new SentMessageViewModel(addMessageToChatCommand.ChatId, inputModel.MessageId, addMessageToChatCommand.SentAt));
    }
}