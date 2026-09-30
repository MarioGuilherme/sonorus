using Microsoft.EntityFrameworkCore;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Repositories;

namespace Sonorus.Account.Infrastructure.Persistence.Repositories;

public class InterestRepository(SonorusAccountDbContext dbContext) : IInterestRepository {
    private readonly SonorusAccountDbContext _dbContext = dbContext;

    public async Task AddAsync(Interest interest) => await _dbContext.Interests.AddAsync(interest);

    public Task<List<Interest>> GetAllAsync() => _dbContext.Interests.AsNoTracking().ToListAsync();

    public Task<Interest?> GetByKeyTrackingAsync(string key) => _dbContext.Interests.FirstOrDefaultAsync(interest => interest.Key == key);

    public Task<Interest?> GetByIdTrackingAsync(long interestId) => _dbContext.Interests.FirstOrDefaultAsync(interest => interest.InterestId == interestId);
}