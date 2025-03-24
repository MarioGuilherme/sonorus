using AutoMapper;
using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Queries.GetAllInterestsFromUser;

public class GetAllInterestsFromUserQueryHandler(IUnitOfWork unitOfWork, IMapper mapper) : IRequestHandler<GetAllInterestsFromUserQuery, IEnumerable<InterestViewModel>> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IMapper _mapper = mapper;

    public async Task<IEnumerable<InterestViewModel>> Handle(GetAllInterestsFromUserQuery request, CancellationToken cancellationToken) {
        User user = await this._unitOfWork.Users.GetByIdTrackingAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();
        return this._mapper.Map<IEnumerable<InterestViewModel>>(user.Interests);
    }
}