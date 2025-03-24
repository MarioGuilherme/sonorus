using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Core.Services;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.RegenerateAccessToken;

public class RegenerateAccessTokenCommandHandler(IAuthService authService, IUnitOfWork unitOfWork) : IRequestHandler<RegenerateAccessTokenCommand, TokenViewModel> {
    private readonly IAuthService _authService = authService;
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<TokenViewModel> Handle(RegenerateAccessTokenCommand request, CancellationToken cancellationToken) {
        string? savedRefreshToken = await this._unitOfWork.RefreshTokens.GetByUserIdAsync(request.UserId);

        if (savedRefreshToken != request.RefreshToken) throw new RefreshTokenNotFoundByUserException();

        User? user = (await this._unitOfWork.Users.GetByIdAsync(request.UserId))!;

        string newJwtToken = this._authService.GenerateToken(user);
        string newRefreshToken = this._authService.GenerateRefreshToken();

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.RefreshTokens.DeleteAsync(new(user.UserId, request.RefreshToken));
        await this._unitOfWork.RefreshTokens.SaveAsync(new(user.UserId, newRefreshToken));
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return new(newJwtToken, newRefreshToken);
    }
}