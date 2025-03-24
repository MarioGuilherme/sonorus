using Sonorus.Business.Core.Repositories;

namespace Sonorus.Business.Infrastructure.Persistence;

public interface IUnitOfWork : IDisposable {
    IOpportunityRepository Opportunities { get; }
    Task<int> CompleteAsync();
    Task BeginTransactionAsync();
    Task CommitAsync();
}