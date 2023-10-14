namespace Sonorus.AccountAPI.DTO;

public class UserDTO {
    public long? UserId { get; set; }

    public string Fullname { get; set; } = null!;

    public string Nickname { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Picture { get; set; }

    public List<InterestDTO> Interests { get; set; } = new();
}