using MediatR;
using Sonorus.Business.Application.ViewModels;

namespace Sonorus.Business.Application.Commands.CreateOpportunity;

public class CreateOpportunityCommand(long userId, CreateOpportunityInputModel inputModel) : CreateOpportunityInputModel(
    inputModel.Name,
    inputModel.BandName,
    inputModel.Description,
    inputModel.ExperienceRequired,
    inputModel.Payment,
    inputModel.IsWork,
    inputModel.WorkTimeUnit
), IRequest<OpportunityViewModel> {
    public long UserId { get; private set; } = userId;
}