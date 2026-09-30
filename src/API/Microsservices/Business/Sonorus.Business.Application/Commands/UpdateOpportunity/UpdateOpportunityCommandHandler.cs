using MediatR;
using Sonorus.Business.Application.ViewModels;
using Sonorus.Business.Core.Entities;
using Sonorus.Business.Core.Exceptions;
using Sonorus.Business.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Business.Application.Commands.UpdateOpportunity;

public class UpdateOpportunityCommandHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory) : IRequestHandler<UpdateOpportunityCommand, OpportunityViewModel>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;

    public async Task<OpportunityViewModel> Handle(UpdateOpportunityCommand request, CancellationToken cancellationToken)
    {
        Opportunity opportunityDb = await _unitOfWork.Opportunities.GetByIdTrackingAsync(request.OpportunityId) ?? throw new OpportunityNotFoundException();

        if (opportunityDb.RecruiterId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfOpportunityException();

        opportunityDb.Update(
            request.Name,
            request.BandName,
            request.Description,
            request.ExperienceRequired,
            request.Payment,
            request.IsWork,
            request.WorkTimeUnit
        );

        await _unitOfWork.BeginTransactionAsync();
        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        using HttpClient userMShttpClient = _httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>($"users?id={request.UserId}", cancellationToken: cancellationToken);

        OpportunityViewModel opportunityViewModel = new(opportunityDb.OpportunityId,
            opportunityDb.Name,
            opportunityDb.BandName,
            opportunityDb.Description,
            opportunityDb.ExperienceRequired,
            opportunityDb.Payment,
            opportunityDb.IsWork,
            opportunityDb.WorkTimeUnit,
            opportunityDb.AnnouncedAt)
        {
            Recruiter = users!.First()
        };

        return opportunityViewModel;
    }
}