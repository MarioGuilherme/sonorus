namespace Sonorus.ChatAPI.DTO;

public class MessageDTO {
    public bool IsSentByMe { get; set; }
    public string Content { get; set; } = null!;
    public DateTime SentAt { get; set; }
}