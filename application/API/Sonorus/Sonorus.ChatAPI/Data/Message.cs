namespace Sonorus.ChatAPI.Data;

public class Message {
    public string MessageId { get; set; } = null!;
    public string Content { get; set; } = null!;
    public DateTime SentAt { get; set; }
    public long SentByUserId { get; set; }
}