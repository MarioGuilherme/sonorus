using Microsoft.EntityFrameworkCore;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Repositories;

namespace Sonorus.Account.Infrastructure.Persistence.Repositories;

public class InterestRepository(SonorusAccountDbContext dbContext) : IInterestRepository {
    private readonly SonorusAccountDbContext _dbContext = dbContext;

    public async Task AddAsync(Interest interest) => await this._dbContext.Interests.AddAsync(interest);

    public Task<List<Interest>> GetAllAsync() => this._dbContext.Interests.AsNoTracking().ToListAsync();

    public Task<Interest?> GetByKeyTrackingAsync(string key) => this._dbContext.Interests.FirstOrDefaultAsync(interest => interest.Key == key);

    public Task<Interest?> GetByIdTrackingAsync(long interestId) => this._dbContext.Interests.FirstOrDefaultAsync(interest => interest.InterestId == interestId);
}