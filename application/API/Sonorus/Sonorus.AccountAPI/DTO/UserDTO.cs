namespace Sonorus.AccountAPI.DTO;

public class UserDTO {
    public int Id { get; set; }

    public string FullName { get; set; } = string.Empty;

    public string Nickname { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string Password { get; set; } = string.Empty;

    public string Token { get; set; } = string.Empty;

    public string RefreshToken { get; set; } = string.Empty;
}