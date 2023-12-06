using Microsoft.EntityFrameworkCore;
using Sonorus.BusinessAPI.Data.Context;
using Sonorus.BusinessAPI.Data.Entities;
using Sonorus.BusinessAPI.Exceptions;

namespace Sonorus.BusinessAPI.Repository.Interfaces;

public class OpportunityRepository : IOpportunityRepository {
    private readonly BusinessAPIDbContext _dbContext;

    public OpportunityRepository(BusinessAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<Opportunity> CreateAsync(long userId, Opportunity opportunity) {
        await _dbContext.Opportunities.AddAsync(opportunity);
        await _dbContext.SaveChangesAsync();
        return opportunity;
    }

    public async Task UpdateAsync(long userId, Opportunity opportunityForm) {
        Opportunity opportunityDB = await this._dbContext.Opportunities.FirstAsync(opportunity => opportunityForm.OpportunityId == opportunity.OpportunityId);

        opportunityDB.Payment = opportunityForm.Payment;
        opportunityDB.IsWork = opportunityForm.IsWork;
        opportunityDB.BandName = opportunityForm.BandName;
        opportunityDB.Description = opportunityForm.Description;
        opportunityDB.ExperienceRequired = opportunityForm.ExperienceRequired;
        opportunityDB.WorkTimeUnit = opportunityForm.WorkTimeUnit;
        opportunityDB.Name = opportunityForm.Name;

        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteOpportunityByIdAsync(long userId, long opportunityId) {
        Opportunity opportunity = await this._dbContext.Opportunities
            .FirstAsync(opportunity => opportunity.OpportunityId == opportunityId);

        if (opportunity.RecruiterId != userId)
            throw new SonorusBusinessAPIException("Esta oportunidade não pertence à você", 403);

        this._dbContext.Opportunities.Remove(opportunity);
        await this._dbContext.SaveChangesAsync();
    }

    public async Task DeleteAllFromuserId(long userId) {
        List<Opportunity> opportunities = this._dbContext.Opportunities.Where(o => o.RecruiterId == userId).ToList();
        this._dbContext.Opportunities.RemoveRange(opportunities);
        await this._dbContext.SaveChangesAsync();
    }

    public async Task<List<Opportunity>> GetAllAsync() => await this._dbContext.Opportunities
        .AsNoTracking()
        .OrderByDescending(opportunity => opportunity.AnnouncedAt)
        .ToListAsync();


    public async Task<List<Opportunity>> GetAllOpportunitiesByNameAsync(string name) {
        List<Opportunity> opportunities = await this._dbContext.Opportunities
            .AsNoTracking()
            .Where(product => product.Name.Contains(name))
            .ToListAsync();

        return opportunities;
    }

    public async Task<List<Opportunity>> GetAllByUserIdAsync(long userId) => await this._dbContext.Opportunities
        .AsNoTracking()
        .Where(opportunity => opportunity.RecruiterId == userId)
        .OrderByDescending(opportunity => opportunity.AnnouncedAt)
        .ToListAsync();
}