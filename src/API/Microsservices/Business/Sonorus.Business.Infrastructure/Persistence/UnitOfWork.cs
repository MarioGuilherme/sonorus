using Microsoft.EntityFrameworkCore.Storage;
using Sonorus.Business.Core.Repositories;

namespace Sonorus.Business.Infrastructure.Persistence;

public class UnitOfWork(SonorusBusinessDbContext dbContext, IOpportunityRepository opportunities) : IUnitOfWork {
    private readonly SonorusBusinessDbContext _dbContext = dbContext;
    private IDbContextTransaction? _transaction;

    public IOpportunityRepository Opportunities => opportunities;

    public Task<int> CompleteAsync() => _dbContext.SaveChangesAsync();

    public async Task BeginTransactionAsync() => _transaction = await _dbContext.Database.BeginTransactionAsync();

    public async Task CommitAsync() {
        try {
            await _transaction!.CommitAsync();
        } catch (Exception) {
            await _transaction!.RollbackAsync();
            throw;
        }
    }

    public void Dispose() {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing) {
        if (disposing)
            _dbContext.Dispose();
    }
}