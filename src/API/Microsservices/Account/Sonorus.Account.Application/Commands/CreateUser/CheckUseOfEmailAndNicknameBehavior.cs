using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.CreateUser;

public class CheckUseOfEmailAndNicknameBehavior(IUnitOfWork unitOfWork) : IPipelineBehavior<CreateUserCommand, TokenViewModel> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<TokenViewModel> Handle(CreateUserCommand request, RequestHandlerDelegate<TokenViewModel> next, CancellationToken cancellationToken) {
        if (await this._unitOfWork.Users.EmailInUseInAsync(request.Email)) throw new EmailAlreadyInUseException();
        if (await this._unitOfWork.Users.NicknameIsInUseAsync(request.Nickname)) throw new NicknameAlreadyInUseException();

        return await next();
    }
}