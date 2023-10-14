namespace Sonorus.PostAPI.DTO;

public class PostDTO {
    public long? PostId { get; set; }

    public UserDTO Author { get; set; } = null!;

    public string? Content { get; set; }

    public DateTime PostedAt { get; set; }

    public long TotalLikes { get; set; }

    public long TotalComments { get; set; }

    public bool IsLikedByMe { get; set; }

    public List<MediaDTO> Medias { get; set; } = new();

    public List<InterestDTO> Interests { get; set; } = new();

    public string? Tablature { get; set; }
}