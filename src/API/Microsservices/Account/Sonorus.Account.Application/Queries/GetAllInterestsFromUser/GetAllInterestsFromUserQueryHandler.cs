using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Queries.GetAllInterestsFromUser;

public class GetAllInterestsFromUserQueryHandler(IUnitOfWork unitOfWork) : IRequestHandler<GetAllInterestsFromUserQuery, IEnumerable<InterestViewModel>>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<IEnumerable<InterestViewModel>> Handle(GetAllInterestsFromUserQuery request, CancellationToken cancellationToken)
    {
        User user = await _unitOfWork.Users.GetByIdTrackingAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();
        return user.Interests.Select(i => new InterestViewModel(i.InterestId, i.Key, i.Value, i.Type));
    }
}