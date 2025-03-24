using MediatR;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.AssociateInterest;

public class AssociateInterestCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<AssociateInterestCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(AssociateInterestCommand request, CancellationToken cancellationToken) {
        User user = await this._unitOfWork.Users.GetByIdTrackingAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();
        Interest interest = await this._unitOfWork.Interests.GetByIdTrackingAsync(request.InterestId) ?? throw new InterestNotFoundException();

        user.Interests.Add(interest);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return Unit.Value;
    }
}