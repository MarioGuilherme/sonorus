using Microsoft.AspNetCore.Http;
using Sonorus.Marketplace.Core.Enums;

namespace Sonorus.Marketplace.Application.Commands.CreateProduct;

public class CreateProductInputModel {
    public string Name { get; set; } = null!;
    public string? Description { get; set; }
    public decimal Price { get; set; }
    public ConditionType Condition { get; set; }
    public IEnumerable<IFormFile> Medias { get; set; } = [];
}