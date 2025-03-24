using MediatR;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.UpdateUser;

public class CheckUseOfEmailAndNicknameBehavior(IUnitOfWork unitOfWork) : IPipelineBehavior<UpdateUserCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(UpdateUserCommand request, RequestHandlerDelegate<Unit> next, CancellationToken cancellationToken) {
        if (await this._unitOfWork.Users.EmailInUseInAsync(request.Email, request.UserId)) throw new EmailAlreadyInUseException();
        if (await this._unitOfWork.Users.NicknameIsInUseAsync(request.Nickname, request.UserId)) throw new NicknameAlreadyInUseException();

        return await next();
    }
}