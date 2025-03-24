using MediatR;

namespace Sonorus.Account.Application.Commands.DeleteUserById;

public class DeleteUserByIdCommand(long userId) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
}