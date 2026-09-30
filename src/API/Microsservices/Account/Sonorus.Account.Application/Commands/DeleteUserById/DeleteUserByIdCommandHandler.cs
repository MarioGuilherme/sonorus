using MediatR;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Events;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Core.MessageBroker;
using Sonorus.Account.Core.Services;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.DeleteUserById;

public class DeleteUserByIdCommandHandler(IUnitOfWork unitOfWork, IFileStorage fileStorage, IMessageBroker messageBroker) : IRequestHandler<DeleteUserByIdCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IFileStorage _fileStorage = fileStorage;
    private readonly IMessageBroker _messageBroker = messageBroker;

    public async Task<Unit> Handle(DeleteUserByIdCommand request, CancellationToken cancellationToken) {
        User user = await _unitOfWork.Users.GetByIdTrackingAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();

        await _unitOfWork.RefreshTokens.DeleteAsync(user.RefreshToken);
        _unitOfWork.Users.Delete(user);

        if (user.Picture is not null) await _fileStorage.DeleteFileAsync(user.Picture);

        await _unitOfWork.BeginTransactionAsync();
        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        DeletedUserEvent deletedUserEvent = new(user.UserId);
        await Task.WhenAll([
            _messageBroker.SendMessageAsync<DeletedUserEvent>(deletedUserEvent, "deleted-users_microservice-business", cancellationToken),
            _messageBroker.SendMessageAsync<DeletedUserEvent>(deletedUserEvent, "deleted-users_microservice-chat", cancellationToken),
            _messageBroker.SendMessageAsync<DeletedUserEvent>(deletedUserEvent, "deleted-users_microservice-marketplace", cancellationToken),
            _messageBroker.SendMessageAsync<DeletedUserEvent>(deletedUserEvent, "deleted-users_microservice-posts", cancellationToken)
        ]);

        return Unit.Value;
    }
}
