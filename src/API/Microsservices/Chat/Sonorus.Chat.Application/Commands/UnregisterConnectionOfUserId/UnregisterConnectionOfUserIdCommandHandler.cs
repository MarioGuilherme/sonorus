using MediatR;
using Sonorus.Chat.Core.Entities;
using Sonorus.Chat.Core.Repositories;

namespace Sonorus.Chat.Application.Commands.UnregisterConnectionOfUserId;

public class UnregisterConnectionOfUserIdCommandHandler(IConnectionRepository connectionRepository) : IRequestHandler<UnregisterConnectionOfUserIdCommand, Unit> {
    private readonly IConnectionRepository _connectionRepository = connectionRepository;

    public async Task<Unit> Handle(UnregisterConnectionOfUserIdCommand request, CancellationToken cancellationToken) {
        Connection? connection = await this._connectionRepository.GetByUserIdAsync(request.UserId);

        if (connection is null) return Unit.Value;

        await this._connectionRepository.DeleteAsync(connection);

        return Unit.Value;
    }
}