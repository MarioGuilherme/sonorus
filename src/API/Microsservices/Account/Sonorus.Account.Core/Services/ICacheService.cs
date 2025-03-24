using Sonorus.Account.Core.Entities;

namespace Sonorus.Account.Core.Services;

public interface ICacheService {
    Task<List<Interest>> GetInterestsAsync();
    void SetInterests(IEnumerable<Interest> interests);
}