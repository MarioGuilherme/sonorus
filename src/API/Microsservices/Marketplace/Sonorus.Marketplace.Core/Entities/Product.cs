using Sonorus.Marketplace.Core.Enums;

namespace Sonorus.Marketplace.Core.Entities;

public class Product(long sellerId, string name, string? description, decimal price, ConditionType condition) {
    public long ProductId { get; private set; }
    public long SellerId { get; private set; } = sellerId;
    public string Name { get; private set; } = name;
    public decimal Price { get; private set; } = price;
    public string? Description { get; private set; } = description;
    public ConditionType Condition { get; private set; } = condition;
    public DateTime AnnouncedAt { get; private set; }
    public ICollection<Media> Medias { get; private set; } = [];

    public void Update(string name, decimal price, string? description, ConditionType condition) {
        this.Name = name;
        this.Price = price;
        this.Description = description;
        this.Condition = condition;
    }
}