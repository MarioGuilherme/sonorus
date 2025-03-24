namespace Sonorus.Post.Application.ViewModels;

public record CommentViewModel(
    long CommentId,
    long TotalLikes,
    DateTime CommentedAt,
    string Content
) {
    public UserViewModel Author { get; set; } = null!;
    public bool IsLikedByMe { get; set; }
}