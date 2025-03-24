using Microsoft.Extensions.Caching.Memory;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Services;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Infrastructure.Services;

public class MemoryCacheService(IUnitOfWork unitOfWork, IMemoryCache memoryCache) : ICacheService {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IMemoryCache _memoryCache = memoryCache;

    public void SetInterests(IEnumerable<Interest> interests) => this._memoryCache.Set("INTERESTS", interests);

    public Task<List<Interest>> GetInterestsAsync() => this._memoryCache.GetOrCreateAsync("INTERESTS", async entry => {
        entry.SetPriority(CacheItemPriority.Normal);
        entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(1);
        return await this._unitOfWork.Interests.GetAllAsync();
    })!;
}