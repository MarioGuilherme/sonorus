using Azure.Messaging.ServiceBus;
using Sonorus.Account.Core.MessageBroker;
using System.Text.Json;

namespace Sonorus.Account.Infrastructure.MessageBroker;

public class AzureServiceBus(ServiceBusClient serviceBusClient) : IMessageBroker {
    private readonly ServiceBusClient _serviceBusClient = serviceBusClient;

    public async Task SendMessageAsync<T>(T message, string queueName, CancellationToken cancellationToken) {
        string body = JsonSerializer.Serialize(message);
        ServiceBusMessage serviceBusMessage = new(body);
        ServiceBusSender serviceBusSender = this._serviceBusClient.CreateSender(queueName);
        await serviceBusSender.SendMessageAsync(serviceBusMessage, cancellationToken);
    }
}