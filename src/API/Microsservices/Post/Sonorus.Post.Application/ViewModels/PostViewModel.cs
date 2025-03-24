namespace Sonorus.Post.Application.ViewModels;

public record PostViewModel(
    long PostId,
    string? Content,
    DateTime PostedAt,
    long TotalLikes,
    long TotalComments,
    string? Tablature,
    IEnumerable<MediaViewModel> Medias
) {
    public UserViewModel Author { get; set; } = null!;
    public bool IsLikedByMe { get; set; }
    public ICollection<InterestViewModel> Interests { get; set; } = [];
}