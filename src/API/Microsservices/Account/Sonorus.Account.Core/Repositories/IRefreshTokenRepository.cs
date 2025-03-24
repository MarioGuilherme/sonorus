using Sonorus.Account.Core.Entities;

namespace Sonorus.Account.Core.Repositories;

public interface IRefreshTokenRepository {
    Task DeleteAsync(RefreshToken refreshToken);
    Task<string?> GetByUserIdAsync(long userId);
    Task SaveAsync(RefreshToken refreshToken);
}