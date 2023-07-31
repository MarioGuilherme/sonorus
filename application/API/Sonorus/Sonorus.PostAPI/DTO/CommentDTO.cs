using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.DTO;

public class CommentDTO {
    public long IdComment { get; set; }

    public string Content { get; set; } = string.Empty;
}