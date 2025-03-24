namespace Sonorus.Chat.Core.Entities;

public class Connection(Guid id, string connectionId, long userId) {
    public Guid Id { get; private set; } = id;
    public string ConnectionId { get; private set; } = connectionId;
    public long UserId { get; private set; } = userId;

    public void UpdateConnectionId(string connectionId) => this.ConnectionId = connectionId;
}