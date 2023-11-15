using Sonorus.BusinessAPI.Data.Entities;
using Sonorus.BusinessAPI.DTO;

namespace Sonorus.BusinessAPI.Services.Interfaces;

public interface IOpportunityService {
    Task<OpportunityDTO> CreateAsync(long userId, OpportunityRegisterDTO opportunityRegister);
    
    Task UpdateAsync(long userId, OpportunityRegisterDTO opportunityRegister);

    Task<List<OpportunityDTO>> GetAllAsync();

    Task<List<OpportunityDTO>> GetAllByUserIdAsync(long userId);

    Task DeleteOpportunityByIdAsync(long userId, long opportunityId);

    Task DeleteAllFromuserId(long userId);
}