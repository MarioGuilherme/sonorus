using AutoMapper;
using MediatR;
using Sonorus.Business.Application.ViewModels;
using Sonorus.Business.Core.Entities;
using Sonorus.Business.Core.Exceptions;
using Sonorus.Business.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Business.Application.Commands.UpdateOpportunity;

public class UpdateOpportunityCommandHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory, IMapper mapper) : IRequestHandler<UpdateOpportunityCommand, OpportunityViewModel> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;
    private readonly IMapper _mapper = mapper;

    public async Task<OpportunityViewModel> Handle(UpdateOpportunityCommand request, CancellationToken cancellationToken) {
        Opportunity opportunityDb = await this._unitOfWork.Opportunities.GetByIdTrackingAsync(request.OpportunityId) ?? throw new OpportunityNotFoundException();
        
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

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>($"users?id={request.UserId}", cancellationToken: cancellationToken);

        OpportunityViewModel opportunityViewModel = this._mapper.Map<OpportunityViewModel>(opportunityDb);
        opportunityViewModel.Recruiter = users!.First();

        return opportunityViewModel;
    }
}