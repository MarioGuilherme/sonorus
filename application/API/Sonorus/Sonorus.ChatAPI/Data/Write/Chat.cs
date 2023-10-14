namespace Sonorus.ChatAPI.Data.Write;

public class Chat {
    public string Id { get; set; } = null!;
    public string ChatId { get; set; } = null!;
    public long[] RelatedUsers { get; set; } = new long[2];
    public List<CleanMessage> Messages { get; set; } = new();
}