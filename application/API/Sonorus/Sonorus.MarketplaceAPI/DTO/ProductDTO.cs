using Sonorus.MarketplaceAPI.Models;

namespace Sonorus.MarketplaceAPI.DTO;

public class ProductDTO {
    public long ProductId { get; set; }

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public decimal Price { get; set; }

    public ConditionType Condition { get; set; }

    public DateTime AnnouncedAt { get; set; }

    public UserDTO Seller { get; set; } = null!;

    public List<MediaDTO> Medias { get; set; } = new();
}