using Sonorus.Account.Core.Repositories;

namespace Sonorus.Account.Infrastructure.Persistence;

public interface IUnitOfWork : IDisposable {
    IInterestRepository Interests { get; }
    IRefreshTokenRepository RefreshTokens { get; }
    IUserRepository Users { get; }
    Task<int> CompleteAsync();
    Task BeginTransactionAsync();
    Task CommitAsync();
}