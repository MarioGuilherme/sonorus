namespace Sonorus.MarketplaceAPI.Models;

public class FieldError {
    public string? Field { get; set; }
    public string Error { get; set; } = null!;
}