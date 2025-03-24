using MediatR;
using Sonorus.Chat.Core.Entities;
using Sonorus.Chat.Core.Repositories;

namespace Sonorus.Chat.Application.Commands.RegisterConnectionOfUserId;

public class RegisterConnectionOfUserIdCommandHandler(IConnectionRepository connectionRepository) : IRequestHandler<RegisterConnectionOfUserIdCommand, Unit> {
    private readonly IConnectionRepository _connectionRepository = connectionRepository;

    public async Task<Unit> Handle(RegisterConnectionOfUserIdCommand request, CancellationToken cancellationToken) {
        Connection? connection = await this._connectionRepository.GetByUserIdAsync(request.UserId);

        if (connection is null) {
            await this._connectionRepository.RegisterConnectionIdOfUserIdAsync(request.UserId, request.ConnectionId);
            return Unit.Value;
        }

        connection.UpdateConnectionId(request.ConnectionId);
        await this._connectionRepository.UpdateAsync(connection);

        return Unit.Value;
    }
}