using AutoMapper;
using Sonorus.BusinessAPI.Data.Entities;
using Sonorus.BusinessAPI.DTO;
using Sonorus.BusinessAPI.Models;
using Sonorus.BusinessAPI.Repository.Interfaces;
using Sonorus.BusinessAPI.Services.Interfaces;

namespace Sonorus.BusinessAPI.Services;

public class OpportunityService : IOpportunityService {
    private readonly IOpportunityRepository _opportunityRepository;
    private readonly IMapper _mapper;
    private readonly HttpClient _httpClient;

    public OpportunityService(IOpportunityRepository opportunityRepository, IMapper mapper, HttpClient httpClient) {
        this._opportunityRepository = opportunityRepository;
        this._mapper = mapper;
        this._httpClient = httpClient;
    }

    public async Task<OpportunityDTO> CreateAsync(long userId, OpportunityRegisterDTO opportunityRegister) {
        Opportunity opportunity = this._mapper.Map<Opportunity>(opportunityRegister);
        opportunity.RecruiterId = userId;
        await this._opportunityRepository.CreateAsync(userId, opportunity);

        this._httpClient.DefaultRequestHeaders.Add("userIds", userId.ToString());
        RestResponse<List<UserDTO>> responseUsers = (await this._httpClient.GetFromJsonAsync<RestResponse<List<UserDTO>>>("api/v1/users/"))!;

        OpportunityDTO mappedOpportunity = this._mapper.Map<OpportunityDTO>(opportunity);

        mappedOpportunity.Recruiter = responseUsers.Data!.First();
        return mappedOpportunity;
    }

    public async Task UpdateAsync(long userId, OpportunityRegisterDTO opportunityRegister) {
        Opportunity opportunity = this._mapper.Map<Opportunity>(opportunityRegister);
        await this._opportunityRepository.UpdateAsync(userId, opportunity);
    }

    public async Task DeleteOpportunityByIdAsync(long userId, long opportunityId) => await this._opportunityRepository.DeleteOpportunityByIdAsync(userId, opportunityId);

    public async Task DeleteAllFromuserId(long userId) => await this._opportunityRepository.DeleteAllFromuserId(userId);

    public async Task<List<OpportunityDTO>> GetAllAsync() {
        List<Opportunity> opportunities = await this._opportunityRepository.GetAllAsync();

        if (!opportunities.Any())
            return new();

        List<long> userIds = opportunities.Select(opportunity => opportunity.RecruiterId).Distinct().ToList();
        this._httpClient.DefaultRequestHeaders.Add("userIds", string.Join(",", userIds));
        RestResponse<List<UserDTO>> responseUsers = (await this._httpClient.GetFromJsonAsync<RestResponse<List<UserDTO>>>("api/v1/users/"))!;

        List<OpportunityDTO> mappedOpportunities = this._mapper.Map<List<Opportunity>, List<OpportunityDTO>>(
            opportunities,
            options => options.AfterMap((oldOpportunities, opportunitiesDTO) => {
                for (int i = 0; i < oldOpportunities.Count; i++)
                    opportunitiesDTO[i].Recruiter = new() { UserId = oldOpportunities[i].RecruiterId };
            })
        );

        mappedOpportunities.ForEach(opportunityMapped => {
            opportunityMapped.Recruiter = responseUsers!.Data!.First(user => opportunityMapped.Recruiter.UserId == user.UserId);
        });

        return mappedOpportunities;
    }


    public async Task<List<OpportunityDTO>> GetAllOpportunitiesByNameAsync(string name) {
        List<Opportunity> opportunities = await this._opportunityRepository.GetAllOpportunitiesByNameAsync(name);

        if (!opportunities.Any())
            return new();

        List<long> userIds = opportunities.Select(opportunity => opportunity.RecruiterId).Distinct().ToList();
        this._httpClient.DefaultRequestHeaders.Add("userIds", string.Join(",", userIds));
        RestResponse<List<UserDTO>> responseUsers = (await this._httpClient.GetFromJsonAsync<RestResponse<List<UserDTO>>>("api/v1/users/"))!;

        List<OpportunityDTO> mappedOpportunities = this._mapper.Map<List<Opportunity>, List<OpportunityDTO>>(
            opportunities,
            options => options.AfterMap((oldOpportunities, opportunitiesDTO) => {
                for (int i = 0; i < oldOpportunities.Count; i++)
                    opportunitiesDTO[i].Recruiter = new() { UserId = oldOpportunities[i].RecruiterId };
            })
        );

        mappedOpportunities.ForEach(opportunityMapped => {
            opportunityMapped.Recruiter = responseUsers!.Data!.First(user => opportunityMapped.Recruiter.UserId == user.UserId);
        });

        return mappedOpportunities;
    }

    public async Task<List<OpportunityDTO>> GetAllByUserIdAsync(long userId) {
        List<Opportunity> opportunities = await this._opportunityRepository.GetAllByUserIdAsync(userId);
        return this._mapper.Map<List<OpportunityDTO>>(opportunities);
    }
}