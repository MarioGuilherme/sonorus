using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Core.Services;
using Sonorus.Account.Infrastructure.Persistence;
using static BCrypt.Net.BCrypt;

namespace Sonorus.Account.Application.Queries.GetUserByLogin;

public class GetUserByLoginQueryHandler(IUnitOfWork unitOfWork, IAuthService authService) : IRequestHandler<GetUserByLoginQuery, TokenViewModel> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IAuthService _authService = authService;

    public async Task<TokenViewModel> Handle(GetUserByLoginQuery request, CancellationToken cancellationToken) {
        User user = await this._unitOfWork.Users.GetByLoginAsync(request.Login) ?? throw new UserNotFoundException();

        if (!Verify(request.Password, user.Password)) throw new UserNotFoundException();

        string refreshTokenString = this._authService.GenerateRefreshToken();

        RefreshToken refreshToken = new(user.UserId, refreshTokenString);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.RefreshTokens.SaveAsync(refreshToken);
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        string accessToken = this._authService.GenerateToken(user);

        return new(accessToken, refreshTokenString);
    }
}