using Microsoft.AspNetCore.Http;

namespace Sonorus.Post.Application.Commands.CreatePost;

public class CreatePostInputModel {
    public string? Content { get; set; }
    public string? Tablature { get; set; }
    public IEnumerable<IFormFile> Medias { get; set; } = [];
    public ICollection<long> InterestsIds { get; set; } = [];
}