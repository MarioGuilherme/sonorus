namespace Sonorus.ChatAPI.DTO;

public class MessageDTO {
    public string MessageId { get; set; } = Guid.NewGuid().ToString();
    public bool IsSentByMe { get; set; }
    public string Content { get; set; } = null!;
    public DateTime SentAt { get; set; }
}