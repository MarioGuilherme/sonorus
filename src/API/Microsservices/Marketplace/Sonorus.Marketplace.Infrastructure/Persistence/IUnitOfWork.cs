using Sonorus.Marketplace.Core.Repositories;

namespace Sonorus.Marketplace.Infrastructure.Persistence;

public interface IUnitOfWork : IDisposable {
    IProductRepository Products { get; }
    Task<int> CompleteAsync();
    Task BeginTransactionAsync();
    Task CommitAsync();
}