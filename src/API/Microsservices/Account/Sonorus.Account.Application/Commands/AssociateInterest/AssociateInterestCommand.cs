using MediatR;

namespace Sonorus.Account.Application.Commands.AssociateInterest;

public class AssociateInterestCommand(long userId, long interestId) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
    public long InterestId { get; private set; } = interestId;
}