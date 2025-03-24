namespace Sonorus.Account.Core.Entities;

public class RefreshToken(long userId, string token) {
    public long RefreshTokenId { get; private set; }
    public long UserId { get; private set; } = userId;
    public User User { get; private set; } = null!;
    public string Token { get; private set; } = token;
}