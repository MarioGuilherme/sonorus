namespace Sonorus.Post.Core.Entities;

public class PostLiker(long userId) {
    public long PostId { get; private set; }
    public Post Post { get; private set; } = null!;
    public long UserId { get; private set; } = userId;
}