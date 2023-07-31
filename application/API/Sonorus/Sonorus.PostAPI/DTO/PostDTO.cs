using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.DTO;

public class PostDTO {
    public long IdPost { get; set; }

    public string Content { get; set; } = string.Empty;

    public List<CommentDTO> Comments { get; set; } = new();
}