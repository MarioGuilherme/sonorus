using Newtonsoft.Json;

namespace Sonorus.Chat.Infrastructure.Persistence.AntiCorruption;

public class CosmosConnection {
    [JsonProperty("id")]
    public string Id { get; set; } = null!;
    [JsonProperty("connectionId")]
    public string ConnectionId { get; set; } = null!;
    [JsonProperty("userId")]
    public long UserId { get; set; }
}