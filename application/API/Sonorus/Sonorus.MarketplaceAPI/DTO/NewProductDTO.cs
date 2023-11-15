using Sonorus.MarketplaceAPI.Models;

namespace Sonorus.MarketplaceAPI.DTO;

public class NewProductDTO {
    public long ProductId { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public decimal Price { get; set; }

    public ConditionType Condition { get; set; }

    public List<string> MediasToKeep { get; set; } = new();
}