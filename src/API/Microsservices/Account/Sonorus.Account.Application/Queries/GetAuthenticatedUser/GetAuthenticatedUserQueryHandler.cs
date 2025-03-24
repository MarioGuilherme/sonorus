using AutoMapper;
using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Queries.GetAuthenticatedUser;

public class GetAuthenticatedUserQueryHandler(IUnitOfWork unitOfWork, IMapper mapper) : IRequestHandler<GetAuthenticatedUserQuery, AuthenticatedUserViewModel> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IMapper _mapper = mapper;

    public async Task<AuthenticatedUserViewModel> Handle(GetAuthenticatedUserQuery request, CancellationToken cancellationToken) {
        User user = await this._unitOfWork.Users.GetByIdAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();
        return this._mapper.Map<AuthenticatedUserViewModel>(user);
    }
}