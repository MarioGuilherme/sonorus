using MediatR;
using Sonorus.Business.Core.Entities;
using Sonorus.Business.Core.Exceptions;
using Sonorus.Business.Infrastructure.Persistence;

namespace Sonorus.Business.Application.Commands.DeleteOpportunity;

public class DeleteOpportunityCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<DeleteOpportunityCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(DeleteOpportunityCommand request, CancellationToken cancellationToken) {
        Opportunity opportunity = await this._unitOfWork.Opportunities.GetByIdTrackingAsync(request.OpportunityId) ?? throw new OpportunityNotFoundException();

        if (opportunity.RecruiterId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfOpportunityException();

        this._unitOfWork.Opportunities.Delete(opportunity);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return Unit.Value;
    }
}