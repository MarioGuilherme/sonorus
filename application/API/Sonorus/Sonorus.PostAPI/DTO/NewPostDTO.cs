namespace Sonorus.PostAPI.DTO;

public class NewPostDTO {
    public long PostId { get; set; }

    public string? Content { get; set; }

    public List<long> InterestsIds { get; set; } = new();

    public string? Tablature { get; set; }

    public List<string> MediasToKeep { get; set; } = new();
}