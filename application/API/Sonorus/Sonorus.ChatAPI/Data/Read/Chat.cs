namespace Sonorus.ChatAPI.Data.Read;

public class Chat {
    public string ChatId { get; set; } = Guid.NewGuid().ToString();
    public long[] RelatedUsers { get; set; } = new long[2];
    public List<Message> Messages { get; set; } = new();
}