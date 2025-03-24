namespace Sonorus.Account.Core.MessageBroker;

public interface IMessageBroker {
    Task SendMessageAsync<T>(T message, string queueName, CancellationToken cancellationToken);
}