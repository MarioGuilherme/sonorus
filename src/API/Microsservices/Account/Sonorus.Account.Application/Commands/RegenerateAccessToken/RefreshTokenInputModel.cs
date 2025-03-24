namespace Sonorus.Account.Application.Commands.RegenerateAccessToken;

public class RefreshTokenInputModel(string refreshToken) {
    public string RefreshToken { get; private set; } = refreshToken;
}