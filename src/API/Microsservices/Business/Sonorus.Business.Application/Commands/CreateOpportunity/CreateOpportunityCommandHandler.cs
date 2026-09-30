using MediatR;
using Sonorus.Business.Application.ViewModels;
using Sonorus.Business.Core.Entities;
using Sonorus.Business.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Business.Application.Commands.CreateOpportunity;

public class CreateOpportunityCommandHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory) : IRequestHandler<CreateOpportunityCommand, OpportunityViewModel>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;

    public async Task<OpportunityViewModel> Handle(CreateOpportunityCommand request, CancellationToken cancellationToken)
    {
        Opportunity opportunity = new(
            request.UserId,
            request.Name,
            request.BandName,
            request.Description,
            request.ExperienceRequired,
            request.Payment,
            request.IsWork,
            request.WorkTimeUnit
        );

        await _unitOfWork.Opportunities.CreateAsync(opportunity);

        await _unitOfWork.BeginTransactionAsync();
        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        using HttpClient userMShttpClient = _httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>($"users?id={request.UserId}", cancellationToken: cancellationToken);

        OpportunityViewModel opportunityViewModel = new(opportunity.OpportunityId,
            opportunity.Name,
            opportunity.BandName,
            opportunity.Description,
            opportunity.ExperienceRequired,
            opportunity.Payment,
            opportunity.IsWork,
            opportunity.WorkTimeUnit,
            opportunity.AnnouncedAt)
        {
            Recruiter = users!.First()
        };

        return opportunityViewModel;
    }
}