using Microsoft.AspNetCore.Http;

namespace Sonorus.Post.Application.Commands.UpdatePost;

public class UpdatePostInputModel {
    public string? Content { get; set; }
    public string? Tablature { get; set; }
    public ICollection<long> InterestsIds { get; set; } = [];
    public ICollection<long> MediasToRemove { get; set; } = [];
    public ICollection<IFormFile> NewMedias { get; set; } = [];
}