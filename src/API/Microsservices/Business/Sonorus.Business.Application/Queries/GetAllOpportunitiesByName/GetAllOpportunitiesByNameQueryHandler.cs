using AutoMapper;
using MediatR;
using Sonorus.Business.Application.ViewModels;
using Sonorus.Business.Core.Entities;
using Sonorus.Business.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Business.Application.Queries.GetAllOpportunitiesByName;

public class GetAllOpportunitiesByNameQueryHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory, IMapper mapper) : IRequestHandler<GetAllOpportunitiesByNameQuery, IEnumerable<OpportunityViewModel>> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;
    private readonly IMapper _mapper = mapper;

    public async Task<IEnumerable<OpportunityViewModel>> Handle(GetAllOpportunitiesByNameQuery request, CancellationToken cancellationToken) {
        IEnumerable<Opportunity> opportunities = await this._unitOfWork.Opportunities.GetAllByNameAsync(request.Name);
        if (!opportunities.Any()) return [];

        IEnumerable<long> userIds = opportunities.Select(opportunity => opportunity.RecruiterId).Distinct();
        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>(
            $"users?{string.Join('&', userIds.Select(userId => $"id={userId}"))}",
            cancellationToken: cancellationToken
        );

        ICollection<OpportunityViewModel> mappedOpportunities = [];
        foreach (Opportunity opportunity in opportunities) {
            UserViewModel? user = users!.FirstOrDefault(user => user.UserId == opportunity.RecruiterId);
            if (user is null) continue;
            OpportunityViewModel opportunityViewModel = this._mapper.Map<OpportunityViewModel>(opportunity);
            opportunityViewModel.Recruiter = user;
            mappedOpportunities.Add(opportunityViewModel);
        }

        return mappedOpportunities;
    }
}