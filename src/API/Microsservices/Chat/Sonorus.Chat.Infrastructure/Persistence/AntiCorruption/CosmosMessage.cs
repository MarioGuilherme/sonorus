using Newtonsoft.Json;

namespace Sonorus.Chat.Infrastructure.Persistence.AntiCorruption;

public class CosmosMessage {
    [JsonProperty("content")]
    public string Content { get; set; } = null!;
    [JsonProperty("sentByUserId")]
    public long SentByUserId { get; set; }
    [JsonProperty("sentAt")]
    public DateTime SentAt { get; set; }
}