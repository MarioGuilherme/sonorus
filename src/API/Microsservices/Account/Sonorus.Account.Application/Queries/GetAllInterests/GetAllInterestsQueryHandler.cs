using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Services;

namespace Sonorus.Account.Application.Queries.GetAllInterests;

public class GetAllInterestsQueryHandler(ICacheService cacheService) : IRequestHandler<GetAllInterestsQuery, IEnumerable<InterestViewModel>>
{
    private readonly ICacheService _cacheService = cacheService;

    public async Task<IEnumerable<InterestViewModel>> Handle(GetAllInterestsQuery request, CancellationToken cancellationToken)
    {
        IEnumerable<Interest> interests = await _cacheService.GetInterestsAsync();
        return interests.Select(i => new InterestViewModel(i.InterestId, i.Key, i.Value, i.Type));
    }
}