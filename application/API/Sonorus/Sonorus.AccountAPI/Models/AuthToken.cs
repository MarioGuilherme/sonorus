namespace Sonorus.AccountAPI.Models;

public class AuthToken {
    public string AccessToken { get; set; } = null!;
    public string? RefreshToken { get; set; }
}