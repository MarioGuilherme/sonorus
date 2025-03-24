using Microsoft.AspNetCore.Http;
using Sonorus.Marketplace.Core.Enums;

namespace Sonorus.Marketplace.Application.Commands.UpdateProduct;

public class UpdateProductInputModel {
    public string Name { get; set; } = null!;
    public string? Description { get; set; }
    public decimal Price { get; set; }
    public ConditionType Condition { get; set; }
    public ICollection<IFormFile> NewMedias { get; set; } = [];
    public ICollection<long> MediasToRemove { get; set; } = [];
}