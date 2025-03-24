using MediatR;

namespace Sonorus.Account.Application.Commands.DisassociateInterest;

public class DisassociateInterestCommand(long userId, long interestId) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
    public long InterestId { get; private set; } = interestId;
}