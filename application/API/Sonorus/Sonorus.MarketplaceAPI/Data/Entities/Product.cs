using System.ComponentModel.DataAnnotations;

namespace Sonorus.MarketplaceAPI.Data.Entities;

public class Product {
    public long ProductId { get; set; }

    public long SellerId { get; set; }

    [Required]
    [StringLength(50)]
    public string Name { get; set; } = null!;

    [StringLength(255)]
    public string? Description { get; set; }

    public decimal Price { get; set; }

    public DateTime AnnouncedAt { get; set; }

    public List<Media> Medias { get; set; } = new();
}