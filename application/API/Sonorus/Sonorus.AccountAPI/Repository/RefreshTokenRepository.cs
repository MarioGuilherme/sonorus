using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Data.Context;
using Sonorus.AccountAPI.Data.Entities;
using Sonorus.AccountAPI.Repository.Interfaces;

namespace Sonorus.AccountAPI.Repository;

public class RefreshTokenRepository : IRefreshTokenRepository {
    private readonly AccountAPIDbContext _dbContext;

    public RefreshTokenRepository(AccountAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task DeleteRefreshTokenAsync(long userId, string refreshToken) {
        RefreshToken refreshTokenDb = await this._dbContext.RefreshTokens.FirstAsync(rt => rt.UserId == userId && rt.Token == refreshToken);
        this._dbContext.RefreshTokens.Remove(refreshTokenDb);
        await this._dbContext.SaveChangesAsync();
    }

    public async Task<string> GetRefreshTokenByUserIdAsync(long userId) => (await this._dbContext.RefreshTokens.AsNoTracking().FirstAsync(rt => rt.UserId == userId)).Token;
    
    public async Task SaveRefreshTokenAsync(long userId, string refreshToken) {
        await this._dbContext.RefreshTokens.AddAsync(new() {
            UserId = userId,
            Token = refreshToken
        });
        await this._dbContext.SaveChangesAsync();
    }
}