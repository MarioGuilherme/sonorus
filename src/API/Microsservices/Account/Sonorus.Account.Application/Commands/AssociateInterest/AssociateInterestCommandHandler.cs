using MediatR;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.AssociateInterest;

public class AssociateInterestCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<AssociateInterestCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(AssociateInterestCommand request, CancellationToken cancellationToken) {
        User user = await _unitOfWork.Users.GetByIdTrackingAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();
        Interest interest = await _unitOfWork.Interests.GetByIdTrackingAsync(request.InterestId) ?? throw new InterestNotFoundException();

        user.Interests.Add(interest);

        await _unitOfWork.BeginTransactionAsync();
        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        return Unit.Value;
    }
}