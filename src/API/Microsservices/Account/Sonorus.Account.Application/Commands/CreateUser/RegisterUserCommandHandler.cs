using AutoMapper;
using MediatR;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Services;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.CreateUser;

public class RegisterUserCommandHandler(IUnitOfWork unitOfWork, IAuthService authService, IMapper mapper) : IRequestHandler<CreateUserCommand, TokenViewModel> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IAuthService _authService = authService;
    private readonly IMapper _mapper = mapper;

    public async Task<TokenViewModel> Handle(CreateUserCommand request, CancellationToken cancellationToken) {
        User user = this._mapper.Map<User>(request);

        await this._unitOfWork.Users.RegisterAsync(user);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();

        string accessToken = this._authService.GenerateToken(user);
        string refreshToken = this._authService.GenerateRefreshToken();

        TokenViewModel tokenViewModel = new(accessToken, refreshToken);

        await this._unitOfWork.RefreshTokens.SaveAsync(new(user.UserId!, tokenViewModel.RefreshToken));
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return tokenViewModel;
    }
}