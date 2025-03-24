using MediatR;
using Sonorus.Account.Application.ViewModels;

namespace Sonorus.Account.Application.Queries.GetAuthenticatedUser;

public class GetAuthenticatedUserQuery(long userId) : IRequest<AuthenticatedUserViewModel> {
    public long UserId { get; private set; } = userId;
}