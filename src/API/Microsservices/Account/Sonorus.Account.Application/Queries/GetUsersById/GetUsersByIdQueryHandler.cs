using AutoMapper;
using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Queries.GetUsersById;

public class GetUsersByIdQueryHandler(IUnitOfWork unitOfWork, IMapper mapper) : IRequestHandler<GetUsersByIdQuery, IEnumerable<UserViewModel>> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IMapper _mapper = mapper;

    public async Task<IEnumerable<UserViewModel>> Handle(GetUsersByIdQuery request, CancellationToken cancellationToken) {
        IEnumerable<User> users = await this._unitOfWork.Users.GetUsersByIdsAsync(request.UserIds);
        return this._mapper.Map<IEnumerable<UserViewModel>>(users);
    }
}