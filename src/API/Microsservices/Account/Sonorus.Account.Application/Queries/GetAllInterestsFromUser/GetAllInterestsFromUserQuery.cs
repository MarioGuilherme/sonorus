using MediatR;
using Sonorus.Account.Application.ViewModels;

namespace Sonorus.Account.Application.Queries.GetAllInterestsFromUser;

public class GetAllInterestsFromUserQuery(long userId) : IRequest<IEnumerable<InterestViewModel>> {
    public long UserId { get; private set; } = userId;
}