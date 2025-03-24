namespace Sonorus.Post.Core.Entities;

public class Comment(long userId, string content) {
    public long CommentId { get; private set; }
    public long PostId { get; private set; }
    public long UserId { get; private set; } = userId;
    public string Content { get; private set; } = content;
    public DateTime CommentedAt { get; private set; }
    public ICollection<CommentLiker> CommentLikers { get; private set; } = [];

    public void UpdateContent(string content) => this.Content = content;
}