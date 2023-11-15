namespace Sonorus.AccountAPI.DTO;

public class ProductDTO {
    public long ProductId { get; set; }

    public string Name { get; set; } = null!;

    public decimal Price { get; set; }

    public string PathOfFirstMedia { get; set; } = null!;
}