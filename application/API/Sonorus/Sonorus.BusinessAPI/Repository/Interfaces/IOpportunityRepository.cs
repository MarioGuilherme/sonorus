using Sonorus.BusinessAPI.Data.Entities;

namespace Sonorus.BusinessAPI.Repository.Interfaces;

public interface IOpportunityRepository {
    Task<Opportunity> CreateAsync(long userId, Opportunity opportunity);

    Task UpdateAsync(long userId, Opportunity opportunityForm);

    Task<List<Opportunity>> GetAllAsync();

    Task<List<Opportunity>> GetAllByUserIdAsync(long userId);

    Task DeleteOpportunityByIdAsync(long userId, long opportunityId);

    Task DeleteAllFromuserId(long userId);
}