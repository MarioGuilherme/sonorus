using MediatR;
using Sonorus.Business.Application.ViewModels;

namespace Sonorus.Business.Application.Commands.UpdateOpportunity;

public class UpdateOpportunityCommand(long userId, long opportunityId, UpdateOpportunityInputModel inputModel) : UpdateOpportunityInputModel(
    inputModel.Name,
    inputModel.BandName,
    inputModel.Description,
    inputModel.ExperienceRequired,
    inputModel.Payment,
    inputModel.IsWork,
    inputModel.WorkTimeUnit
), IRequest<OpportunityViewModel> {
    public long UserId { get; private set; } = userId;
    public long OpportunityId { get; private set; } = opportunityId;
}