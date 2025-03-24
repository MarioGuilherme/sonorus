using Azure.Messaging.ServiceBus;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Sonorus.Chat.Core.Entities;
using Sonorus.Chat.Core.Events;
using Sonorus.Chat.Core.Repositories;
using System.Text.Json;

namespace Sonorus.Chat.Application.Subscribers;

public class DeletedUserSubscriber(IServiceProvider serviceProvider) : BackgroundService {
    private readonly IServiceProvider _serviceProvider = serviceProvider;
    private readonly ServiceBusProcessor _processor = serviceProvider.CreateScope().ServiceProvider.GetRequiredService<ServiceBusProcessor>();

    protected override async Task ExecuteAsync(CancellationToken stoppingToken) {
        this._processor.ProcessMessageAsync += this.ProcessMessageAsync;
        this._processor.ProcessErrorAsync += this.ProcessErrorAsync;

        await this._processor.StartProcessingAsync(stoppingToken);
    }

    public async Task ProcessMessageAsync(ProcessMessageEventArgs args) {
        string jsonString = args.Message.Body.ToString();

        DeletedUserIdEvent deletedUserIdEvent = JsonSerializer.Deserialize<DeletedUserIdEvent>(jsonString)!;

        await this.ProcessDeletedUserAsync(deletedUserIdEvent);

        await args.CompleteMessageAsync(args.Message);
    }

    private async Task ProcessDeletedUserAsync(DeletedUserIdEvent deletedUserIdEvent) {
        using IServiceScope scope = this._serviceProvider.CreateScope();
        IConnectionRepository connectionRepository = scope.ServiceProvider.GetRequiredService<IConnectionRepository>();
        IChatRepository chatRepository = scope.ServiceProvider.GetRequiredService<IChatRepository>();

        Connection? connection = await connectionRepository.GetByUserIdAsync(deletedUserIdEvent.UserId);
        IEnumerable<Core.Entities.Chat> chats = await chatRepository.GetAllChatByUserIdAsync(deletedUserIdEvent.UserId);

        if (connection is not null) await connectionRepository.DeleteAsync(connection);

        foreach (Core.Entities.Chat chat in chats) {
            if (chat.Participants.Count() == 2) {
                await chatRepository.DeleteAsync(chat);
                continue;
            }

            chat.Messages.Where(message => message.SentByUserId == deletedUserIdEvent.UserId)
                .ToList()
                .ForEach(message => chat.Messages.Remove(message));
            await chatRepository.UpdateAsync(chat);
        }
    }

    private Task ProcessErrorAsync(ProcessErrorEventArgs args) {
        Console.WriteLine($"Erro no Service Bus: {args.Exception.Message}");
        return Task.CompletedTask;
    }
}