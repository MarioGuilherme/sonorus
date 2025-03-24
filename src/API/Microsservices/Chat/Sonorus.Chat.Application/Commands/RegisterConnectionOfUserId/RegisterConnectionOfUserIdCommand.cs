using MediatR;

namespace Sonorus.Chat.Application.Commands.RegisterConnectionOfUserId;

public class RegisterConnectionOfUserIdCommand(long userId, string connectionId) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
    public string ConnectionId { get; private set; } = connectionId;
}