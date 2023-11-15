namespace Sonorus.PostAPI.DTO;

public class CommentDTO {
    public long? CommentId { get; set; }

    public UserDTO? Author { get; set; }

    public long TotalLikes { get; set; }

    public bool IsLikedByMe { get; set; }

    public DateTime CommentedAt { get; set; }

    public string Content { get; set; } = null!;
}