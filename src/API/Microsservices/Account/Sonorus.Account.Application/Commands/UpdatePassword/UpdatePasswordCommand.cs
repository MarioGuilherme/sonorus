using MediatR;

namespace Sonorus.Account.Application.Commands.UpdatePassword;

public class UpdatePasswordCommand(long userId, string newPassword) : UpdatePasswordInputModel(newPassword), IRequest<Unit> {
    public long UserId { get; private set; } = userId;
}