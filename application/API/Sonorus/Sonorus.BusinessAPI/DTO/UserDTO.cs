namespace Sonorus.BusinessAPI.DTO;

public class UserDTO {
    public long UserId { get; set; }
    public string Nickname { get; set; } = null!;
    public string? Picture { get; set; }
}