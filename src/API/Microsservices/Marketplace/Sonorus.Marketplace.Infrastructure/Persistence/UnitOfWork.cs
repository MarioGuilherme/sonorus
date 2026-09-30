using Microsoft.EntityFrameworkCore.Storage;
using Sonorus.Marketplace.Core.Repositories;

namespace Sonorus.Marketplace.Infrastructure.Persistence;

public class UnitOfWork(SonorusMarketplaceDbContext dbContext, IProductRepository products) : IUnitOfWork
{
    private readonly SonorusMarketplaceDbContext _dbContext = dbContext;
    private IDbContextTransaction? _transaction;

    public IProductRepository Products => products;

    public Task<int> CompleteAsync() => _dbContext.SaveChangesAsync();

    public async Task BeginTransactionAsync() => _transaction = await _dbContext.Database.BeginTransactionAsync();

    public async Task CommitAsync()
    {
        try
        {
            await _transaction!.CommitAsync();
        }
        catch (Exception)
        {
            await _transaction!.RollbackAsync();
            throw;
        }
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (disposing)
            _dbContext.Dispose();
    }
}