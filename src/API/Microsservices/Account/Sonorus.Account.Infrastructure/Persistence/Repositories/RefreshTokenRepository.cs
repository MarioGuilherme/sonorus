using Microsoft.EntityFrameworkCore;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Repositories;

namespace Sonorus.Account.Infrastructure.Persistence.Repositories;

public class RefreshTokenRepository(SonorusAccountDbContext dbContext) : IRefreshTokenRepository {
    private readonly SonorusAccountDbContext _dbContext = dbContext;

    public async Task DeleteAsync(RefreshToken refreshToken) {
        if (refreshToken.RefreshTokenId is 0) {
            RefreshToken refreshTokenDb = await this._dbContext.RefreshTokens.FirstAsync(rt => rt.UserId == refreshToken.UserId && rt.Token == refreshToken.Token);
            this._dbContext.RefreshTokens.Remove(refreshTokenDb);
            return;
        }
        this._dbContext.RefreshTokens.Remove(refreshToken);
    }

    public async Task<string?> GetByUserIdAsync(long userId) => (await this._dbContext.RefreshTokens
        .AsNoTracking()
        .FirstOrDefaultAsync(rt => rt.UserId == userId))?.Token;

    public async Task SaveAsync(RefreshToken refreshToken) {
        IEnumerable<RefreshToken> oldRefreshTokensOfThisUser = await this._dbContext.RefreshTokens.Where(rt => rt.UserId == refreshToken.UserId).ToListAsync();
        this._dbContext.RefreshTokens.RemoveRange(oldRefreshTokensOfThisUser);
        await this._dbContext.RefreshTokens.AddAsync(refreshToken);
    }
}