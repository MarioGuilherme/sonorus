using MediatR;
using Sonorus.Business.Core.Entities;
using Sonorus.Business.Core.Exceptions;
using Sonorus.Business.Infrastructure.Persistence;

namespace Sonorus.Business.Application.Commands.DeleteOpportunity;

public class DeleteOpportunityCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<DeleteOpportunityCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(DeleteOpportunityCommand request, CancellationToken cancellationToken) {
        Opportunity opportunity = await _unitOfWork.Opportunities.GetByIdTrackingAsync(request.OpportunityId) ?? throw new OpportunityNotFoundException();

        if (opportunity.RecruiterId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfOpportunityException();

        _unitOfWork.Opportunities.Delete(opportunity);

        await _unitOfWork.BeginTransactionAsync();
        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        return Unit.Value;
    }
}