namespace Sonorus.Post.Core.Entities;

public class CommentLiker(long userId) {
    public long CommentId { get; private set; }
    public Comment Comment { get; private set; } = null!;
    public long UserId { get; private set; } = userId;
}