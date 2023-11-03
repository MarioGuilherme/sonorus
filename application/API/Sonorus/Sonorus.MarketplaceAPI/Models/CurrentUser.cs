namespace Sonorus.MarketplaceAPI.Models;

public class CurrentUser {
    public long? UserId { get; set; }
    public string Token { get; set; } = null!;
}