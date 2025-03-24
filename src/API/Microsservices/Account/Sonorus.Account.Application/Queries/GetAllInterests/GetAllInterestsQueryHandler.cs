using AutoMapper;
using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Services;

namespace Sonorus.Account.Application.Queries.GetAllInterests;

public class GetAllInterestsQueryHandler(IMapper mapper, ICacheService cacheService) : IRequestHandler<GetAllInterestsQuery, IEnumerable<InterestViewModel>> {
    private readonly ICacheService _cacheService = cacheService;
    private readonly IMapper _mapper = mapper;

    public async Task<IEnumerable<InterestViewModel>> Handle(GetAllInterestsQuery request, CancellationToken cancellationToken) {
        IEnumerable<Interest> interests = await this._cacheService.GetInterestsAsync();
        return this._mapper.Map<IEnumerable<InterestViewModel>>(interests);
    }
}