using MediatR;
using Sonorus.Account.Application.ViewModels;

namespace Sonorus.Account.Application.Queries.GetUsersById;

public class GetUsersByIdQuery(IEnumerable<long> userIds) : IRequest<IEnumerable<UserViewModel>> {
    public IEnumerable<long> UserIds { get; private set; } = userIds;
}