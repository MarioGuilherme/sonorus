using AutoMapper;
using Microsoft.Extensions.Caching.Memory;
using Sonorus.AccountAPI.Core;
using Sonorus.AccountAPI.Data.Entities;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Services.Interfaces;

namespace Sonorus.AccountAPI.Services;

public class InterestService : BaseService, IInterestService {
    private readonly IInterestRepository _interestRepository;
    private readonly IMapper _mapper;
    private readonly IMemoryCache _memoryCache;

    public InterestService(IInterestRepository interestRepository, IMapper mapper, IMemoryCache memoryCache) {
        this._interestRepository = interestRepository;
        this._mapper = mapper;
        this._memoryCache = memoryCache;
    }

    public async Task<List<InterestDTO>> GetAllAsync() {
        List<Interest> interests = (await this._memoryCache.GetOrCreateAsync("INTERESTS", async entry => {
            entry.SetPriority(CacheItemPriority.Normal);
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromSeconds(30);
            return await this._interestRepository.GetAllAsync();
        }))!;
        return this._mapper.Map<List<InterestDTO>>(interests);
    }
}