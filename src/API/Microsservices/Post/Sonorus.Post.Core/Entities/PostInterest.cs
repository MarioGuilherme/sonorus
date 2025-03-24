namespace Sonorus.Post.Core.Entities;

public class PostInterest(long interestId) {
    public long PostId { get; private set; }
    public Post Post { get; private set; } = null!;
    public long InterestId { get; private set; } = interestId;
}