using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Data.Context;
using Sonorus.AccountAPI.Data.Entities;
using Sonorus.AccountAPI.Repository.Interfaces;

namespace Sonorus.AccountAPI.Repository;

public class InterestRepository : IInterestRepository {
    private readonly AccountAPIDbContext _dbContext;

    public InterestRepository(AccountAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<List<Interest>> GetAll() => await this._dbContext.Interests.AsNoTracking().ToListAsync();
}