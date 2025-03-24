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
        User user = await this._unitOfWork.Users.GetByIdTrackingAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();

        await this._unitOfWork.RefreshTokens.DeleteAsync(user.RefreshToken);
        this._unitOfWork.Users.Delete(user);

        if (user.Picture is not null) await this._fileStorage.DeleteFileAsync(user.Picture);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        await Task.WhenAll([
            this._messageBroker.SendMessageAsync<DeletedUserEvent>(new(user.UserId), "deleted-users_microservice-business", cancellationToken),
            this._messageBroker.SendMessageAsync<DeletedUserEvent>(new(user.UserId), "deleted-users_microservice-chat", cancellationToken),
            this._messageBroker.SendMessageAsync<DeletedUserEvent>(new(user.UserId), "deleted-users_microservice-marketplace", cancellationToken),
            this._messageBroker.SendMessageAsync<DeletedUserEvent>(new(user.UserId), "deleted-users_microservice-posts", cancellationToken)
        ]);

        return Unit.Value;
    }
}