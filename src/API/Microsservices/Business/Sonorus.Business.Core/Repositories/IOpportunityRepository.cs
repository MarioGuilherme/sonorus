using Sonorus.Business.Core.Entities;

namespace Sonorus.Business.Core.Repositories;

public interface IOpportunityRepository {
    Task CreateAsync(Opportunity opportunity);
    void Delete(Opportunity opportunity);
    void DeleteAllFromUserId(long userId);
    Task<List<Opportunity>> GetAllByNameAsync(string? name);
    Task<Opportunity?> GetByIdTrackingAsync(long opportunityId);
}