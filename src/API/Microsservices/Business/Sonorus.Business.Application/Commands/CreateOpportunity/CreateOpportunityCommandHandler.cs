using AutoMapper;
using MediatR;
using Sonorus.Business.Application.ViewModels;
using Sonorus.Business.Core.Entities;
using Sonorus.Business.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Business.Application.Commands.CreateOpportunity;

public class CreateOpportunityCommandHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory, IMapper mapper) : IRequestHandler<CreateOpportunityCommand, OpportunityViewModel> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;
    private readonly IMapper _mapper = mapper;

    public async Task<OpportunityViewModel> Handle(CreateOpportunityCommand request, CancellationToken cancellationToken) {
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

        await this._unitOfWork.Opportunities.CreateAsync(opportunity);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>($"users?id={request.UserId}", cancellationToken: cancellationToken);

        OpportunityViewModel opportunityViewModel = this._mapper.Map<OpportunityViewModel>(opportunity);
        opportunityViewModel.Recruiter = users!.First();

        return opportunityViewModel;
    }
}