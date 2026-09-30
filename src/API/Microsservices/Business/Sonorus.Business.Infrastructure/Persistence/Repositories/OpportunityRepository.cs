using Microsoft.EntityFrameworkCore;
using Sonorus.Business.Core.Entities;
using Sonorus.Business.Core.Repositories;

namespace Sonorus.Business.Infrastructure.Persistence.Repositories;

public class OpportunityRepository(SonorusBusinessDbContext dbContext) : IOpportunityRepository
{
    private readonly SonorusBusinessDbContext _dbContext = dbContext;

    public async Task CreateAsync(Opportunity opportunity)
    {
        await _dbContext.Opportunities.AddAsync(opportunity);
    }

    public void Delete(Opportunity opportunity) => _dbContext.Opportunities.Remove(opportunity);

    public void DeleteAllFromUserId(long userId)
    {
        List<Opportunity> opportunities = [.. _dbContext.Opportunities.Where(opportunity => opportunity.RecruiterId == userId)];
        _dbContext.Opportunities.RemoveRange(opportunities);
    }

    public Task<List<Opportunity>> GetAllByNameAsync(string? name) => _dbContext.Opportunities
        .AsNoTracking()
        .Where(product => name == null || (name != null && product.Name.Contains(name)))
        .ToListAsync();

    public Task<Opportunity?> GetByIdTrackingAsync(long opportunityId) => _dbContext.Opportunities.FirstOrDefaultAsync(opportunity => opportunity.OpportunityId == opportunityId);
}