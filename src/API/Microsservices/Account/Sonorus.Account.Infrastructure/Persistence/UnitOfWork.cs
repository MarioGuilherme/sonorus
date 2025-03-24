using Microsoft.EntityFrameworkCore.Storage;
using Sonorus.Account.Core.Repositories;

namespace Sonorus.Account.Infrastructure.Persistence;

public class UnitOfWork(
    SonorusAccountDbContext dbContext,
    IInterestRepository interests,
    IRefreshTokenRepository refreshTokens,
    IUserRepository users
) : IUnitOfWork {
    private readonly SonorusAccountDbContext _dbContext = dbContext;
    private IDbContextTransaction? _transaction;

    public IInterestRepository Interests => interests;
    public IRefreshTokenRepository RefreshTokens => refreshTokens;
    public IUserRepository Users => users;

    public Task<int> CompleteAsync() => this._dbContext.SaveChangesAsync();

    public async Task BeginTransactionAsync() => this._transaction = await this._dbContext.Database.BeginTransactionAsync();

    public async Task CommitAsync() {
        try {
            await this._transaction!.CommitAsync();
        } catch (Exception) {
            await this._transaction!.RollbackAsync();
            throw;
        }
    }

    public void Dispose() {
        this.Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing) {
        if (disposing)
            this._dbContext.Dispose();
    }
}