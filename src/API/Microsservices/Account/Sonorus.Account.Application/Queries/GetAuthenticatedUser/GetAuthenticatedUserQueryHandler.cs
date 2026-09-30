using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Queries.GetAuthenticatedUser;

public class GetAuthenticatedUserQueryHandler(IUnitOfWork unitOfWork) : IRequestHandler<GetAuthenticatedUserQuery, AuthenticatedUserViewModel>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<AuthenticatedUserViewModel> Handle(GetAuthenticatedUserQuery request, CancellationToken cancellationToken)
    {
        User user = await _unitOfWork.Users.GetByIdAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();
        return new(user.UserId, user.Fullname, user.Nickname, user.Email, user.Picture);
    }
}