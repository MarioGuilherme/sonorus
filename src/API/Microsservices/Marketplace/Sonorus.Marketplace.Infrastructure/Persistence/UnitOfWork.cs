using Microsoft.EntityFrameworkCore.Storage;
using Sonorus.Marketplace.Core.Repositories;

namespace Sonorus.Marketplace.Infrastructure.Persistence;

public class UnitOfWork(SonorusMarketplaceDbContext dbContext, IProductRepository products) : IUnitOfWork {
    private readonly SonorusMarketplaceDbContext _dbContext = dbContext;
    private IDbContextTransaction? _transaction;

    public IProductRepository Products => products;

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