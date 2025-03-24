using Microsoft.EntityFrameworkCore.Storage;
using Sonorus.Post.Core.Repositories;

namespace Sonorus.Post.Infrastructure.Persistence;

public class UnitOfWork(
    SonorusPostDbContext dbContext,
    IPostRepository posts
) : IUnitOfWork {
    private readonly SonorusPostDbContext _dbContext = dbContext;
    private IDbContextTransaction? _transaction;

    public IPostRepository Posts => posts;

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