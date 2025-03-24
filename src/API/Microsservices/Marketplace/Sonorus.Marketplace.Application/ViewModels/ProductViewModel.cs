using Sonorus.Marketplace.Core.Enums;

namespace Sonorus.Marketplace.Application.ViewModels;

public record ProductViewModel(
    long ProductId,
    string Name,
    decimal Price,
    string? Description,
    ConditionType Condition,
    DateTime AnnouncedAt,
    IEnumerable<MediaViewModel> Medias
) {
    public UserViewModel Seller { get; set; } = null!;
};