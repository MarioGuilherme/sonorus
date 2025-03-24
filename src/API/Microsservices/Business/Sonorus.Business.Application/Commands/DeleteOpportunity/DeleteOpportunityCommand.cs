using MediatR;

namespace Sonorus.Business.Application.Commands.DeleteOpportunity;

public class DeleteOpportunityCommand(long userId, long opportunityId) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
    public long OpportunityId { get; private set; } = opportunityId;
}