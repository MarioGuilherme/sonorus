using MediatR;
using Sonorus.Account.Application.ViewModels;

namespace Sonorus.Account.Application.Commands.RegenerateAccessToken;

public class RegenerateAccessTokenCommand(long userId, string refreshToken) : RefreshTokenInputModel(refreshToken), IRequest<TokenViewModel> {
    public long UserId { get; private set; } = userId;
}