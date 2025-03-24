using Sonorus.Post.Core.Repositories;

namespace Sonorus.Post.Infrastructure.Persistence;

public interface IUnitOfWork : IDisposable {
    IPostRepository Posts { get; }
    Task<int> CompleteAsync();
    Task BeginTransactionAsync();
    Task CommitAsync();
}