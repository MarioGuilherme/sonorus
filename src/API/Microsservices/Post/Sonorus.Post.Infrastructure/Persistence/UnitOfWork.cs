using Microsoft.EntityFrameworkCore.Storage;
using Sonorus.Post.Core.Repositories;

namespace Sonorus.Post.Infrastructure.Persistence;

public class UnitOfWork(
    SonorusPostDbContext dbContext,
    IPostRepository posts
) : IUnitOfWork
{
    private readonly SonorusPostDbContext _dbContext = dbContext;
    private IDbContextTransaction? _transaction;

    public IPostRepository Posts => posts;

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