using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Services;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.CreateUser;

public class RegisterUserCommandHandler(IUnitOfWork unitOfWork, IAuthService authService) : IRequestHandler<CreateUserCommand, TokenViewModel>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IAuthService _authService = authService;

    public async Task<TokenViewModel> Handle(CreateUserCommand request, CancellationToken cancellationToken)
    {
        User user = new(request.Fullname, request.Nickname, request.Email, request.Password);

        await _unitOfWork.Users.RegisterAsync(user);

        await _unitOfWork.BeginTransactionAsync();
        await _unitOfWork.CompleteAsync();

        string accessToken = _authService.GenerateToken(user);
        string refreshToken = _authService.GenerateRefreshToken();

        TokenViewModel tokenViewModel = new(accessToken, refreshToken);

        await _unitOfWork.RefreshTokens.SaveAsync(new(user.UserId!, tokenViewModel.RefreshToken));
        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        return tokenViewModel;
    }
}