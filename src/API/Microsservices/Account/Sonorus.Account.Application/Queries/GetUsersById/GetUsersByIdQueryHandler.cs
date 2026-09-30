using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Queries.GetUsersById;

public class GetUsersByIdQueryHandler(IUnitOfWork unitOfWork) : IRequestHandler<GetUsersByIdQuery, IEnumerable<UserViewModel>>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<IEnumerable<UserViewModel>> Handle(GetUsersByIdQuery request, CancellationToken cancellationToken)
    {
        IEnumerable<User> users = await _unitOfWork.Users.GetUsersByIdsAsync(request.UserIds);
        return users.Select(u => new UserViewModel(u.UserId,
            u.Fullname,
            u.Nickname,
            u.Email,
            u.Picture,
            u.Interests.Select(i => new InterestViewModel(i.InterestId,
                i.Key,
                i.Value,
                i.Type))));
    }
}