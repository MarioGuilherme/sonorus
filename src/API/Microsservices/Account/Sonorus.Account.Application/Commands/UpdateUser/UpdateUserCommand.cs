using MediatR;
using Microsoft.AspNetCore.Http;

namespace Sonorus.Account.Application.Commands.UpdateUser;

public class UpdateUserCommand(long userId, UpdateUserInputModel inputModel) : UpdateUserInputModel(
    inputModel.Fullname,
    inputModel.Nickname,
    inputModel.Email
), IRequest<Unit> {
    public long UserId { get; private set; } = userId;
    public IEnumerable<IFormFile> Medias { get; private set; } = [];
}