using Sonorus.Account.Core.Entities;

namespace Sonorus.Account.Core.Repositories;

public interface IInterestRepository {
    Task AddAsync(Interest interest);
    Task<List<Interest>> GetAllAsync();
    Task<Interest?> GetByKeyTrackingAsync(string key);
    Task<Interest?> GetByIdTrackingAsync(long interestId);
}