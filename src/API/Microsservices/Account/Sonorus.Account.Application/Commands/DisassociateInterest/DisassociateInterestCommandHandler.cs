using MediatR;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.DisassociateInterest;

public class DisassociateInterestCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<DisassociateInterestCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(DisassociateInterestCommand request, CancellationToken cancellationToken) {
        User user = await this._unitOfWork.Users.GetByIdTrackingAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();
        Interest interest = user.Interests.FirstOrDefault(interest => interest.InterestId == request.InterestId) ?? throw new InterestNotFoundException();

        user.Interests.Remove(interest);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return Unit.Value;
    }
}