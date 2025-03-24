using MediatR;

namespace Sonorus.Chat.Application.Commands.UnregisterConnectionOfUserId;

public class UnregisterConnectionOfUserIdCommand(long userId) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
}