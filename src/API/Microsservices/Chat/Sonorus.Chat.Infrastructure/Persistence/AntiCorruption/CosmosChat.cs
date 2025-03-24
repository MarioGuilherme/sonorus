using Newtonsoft.Json;

namespace Sonorus.Chat.Infrastructure.Persistence.AntiCorruption;

public class CosmosChat {
    [JsonProperty("id")]
    public string Id { get; set; } = null!;
    [JsonProperty("chatId")]
    public string ChatId { get; set; } = null!;
    [JsonProperty("messages")]
    public List<CosmosMessage> Messages { get; set; } = null!;
    [JsonProperty("participants")]
    public List<long> Participants { get; set; } = null!;
}