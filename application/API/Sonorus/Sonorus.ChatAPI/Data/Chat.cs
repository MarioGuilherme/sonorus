namespace Sonorus.ChatAPI.Data;

public class Chat {
    public string Id { get; set; } = null!;
    public string ChatId { get; set; } = null!;
    public long[] RelatedUsersId { get; set; } = new long[2];
    public List<Message> Messages { get; set; } = new();
}