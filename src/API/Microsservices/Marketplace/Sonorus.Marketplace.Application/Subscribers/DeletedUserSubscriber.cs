using Azure.Messaging.ServiceBus;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Sonorus.Marketplace.Core.Events;
using Sonorus.Marketplace.Core.Services;
using Sonorus.Marketplace.Infrastructure.Persistence;
using System.Text.Json;

namespace Sonorus.Marketplace.Application.Subscribers;

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
        IFileStorage fileStorage = scope.ServiceProvider.GetRequiredService<IFileStorage>();
        IUnitOfWork unitOfWork = scope.ServiceProvider.GetRequiredService<IUnitOfWork>();
        IEnumerable<string> medias = unitOfWork.Products.DeleteAllFromUserId(deletedUserIdEvent.UserId);

        foreach (string media in medias) await fileStorage.DeleteFileAsync(Path.GetFileName(media));

        await unitOfWork.BeginTransactionAsync();
        await unitOfWork.CompleteAsync();
        await unitOfWork.CommitAsync();
    }

    private Task ProcessErrorAsync(ProcessErrorEventArgs args) {
        Console.WriteLine($"Erro no Service Bus: {args.Exception.Message}");
        return Task.CompletedTask;
    }
}