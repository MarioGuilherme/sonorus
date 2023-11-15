namespace Sonorus.PostAPI.DTO;

public class NewCommentDTO {
    public long PostId { get; set; }
    public string Content { get; set; } = null!;
}