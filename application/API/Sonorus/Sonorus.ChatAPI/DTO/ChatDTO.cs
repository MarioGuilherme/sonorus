using Sonorus.ChatAPI.Data.Write;
using Sonorus.ChatAPI.DTO;

public class ChatDTO {
    public string ChatId { get; set; } = Guid.NewGuid().ToString();
    public Sonorus.ChatAPI.Data.Read.User Friend { get; set; } = null!;
    public List<MessageDTO> Messages { get; set; } = new();
}