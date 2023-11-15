namespace Sonorus.AccountAPI.DTO;

public class CompleteUserDTO {
    public long? UserId { get; set; }

    public string Fullname { get; set; } = null!;

    public string Nickname { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Picture { get; set; }

    public List<InterestDTO> Interests { get; set; } = new();

    public List<PostDTO> Posts { get; set; } = new();

    public List<OpportunityDTO> Opportunities { get; set; } = new();

    public List<ProductDTO> Products { get; set; } = new();
}