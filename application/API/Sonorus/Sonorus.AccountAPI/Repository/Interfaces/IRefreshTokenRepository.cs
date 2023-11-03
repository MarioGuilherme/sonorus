namespace Sonorus.AccountAPI.Repository.Interfaces;

public interface IRefreshTokenRepository {
    Task DeleteRefreshTokenAsync(long userId, string refreshToken);

    Task<string> GetRefreshTokenByUserIdAsync(long userId);

    Task SaveRefreshTokenAsync(long userId, string refreshToken);
}