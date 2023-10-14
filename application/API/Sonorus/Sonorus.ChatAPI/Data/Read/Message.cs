namespace Sonorus.ChatAPI.Data.Read;

public class Message {
    public string MessageId { get; set; } = Guid.NewGuid().ToString();
    public long SentByUserId { get; set; }
    public string Content { get; set; } = null!;
    public DateTime SentAt { get; set; }
}