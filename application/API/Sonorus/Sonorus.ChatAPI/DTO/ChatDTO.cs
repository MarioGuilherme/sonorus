using Sonorus.ChatAPI.Data;
using Sonorus.ChatAPI.DTO;

public class ChatDTO {
    public string ChatId { get; set; }
    public User Friend { get; set; } = null!;
    public List<MessageDTO> Messages { get; set; } = new();
}