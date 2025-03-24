namespace Sonorus.Post.Core.Entities;

public class Post(long userId, string? content, string? tablature) {
    public long PostId { get; private set; }
    public long UserId { get; private set; } = userId;
    public string? Content { get; private set; } = content;
    public string? Tablature { get; private set; } = tablature;
    public DateTime PostedAt { get; private set; }
    public ICollection<PostLiker> PostLikers { get; private set; } = [];
    public ICollection<Media> Medias { get; private set; } = [];
    public ICollection<Comment> Comments { get; private set; } = [];
    public ICollection<PostInterest> PostInterests { get; private set; } = [];

    public void Update(string? content, string? tablature) {
        this.Content = content;
        this.Tablature = tablature;
    }
}