namespace Sonorus.ChatAPI.Data.Write;

public class Message {
    public string Id { get; set; } = Guid.NewGuid().ToString();
    public string MessageId { get; set; } = Guid.NewGuid().ToString();
    public long SentByUserId { get; set; }
    public string Content { get; set; } = null!;
    public DateTime SentAt { get; set; }
}

public class CleanMessage {
    public string MessageId { get; set; } = null!;
}