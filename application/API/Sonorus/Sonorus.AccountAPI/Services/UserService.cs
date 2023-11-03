using AutoMapper;
using Azure.Storage.Blobs;
using Microsoft.Extensions.Primitives;
using Sonorus.AccountAPI.Core;
using Sonorus.AccountAPI.Data.Entities;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Services.Interfaces;
using Sonorus.AccountAPI.Services.Validator;
using System.Text.Json;
using static BCrypt.Net.BCrypt;

namespace Sonorus.AccountAPI.Services;

public class UserService : BaseService, IUserService {
    private readonly TokenService _tokenService;
    private readonly IUserRepository _userRepository;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IInterestRepository _interestRepository;
    private readonly IMapper _mapper;

    public UserService(
        TokenService tokenService,
        IUserRepository userRepository,
        IRefreshTokenRepository refreshTokenRepository,
        IInterestRepository interestRepository,
        IMapper mapper
    ) {
        this._tokenService = tokenService;
        this._userRepository = userRepository;
        this._refreshTokenRepository = refreshTokenRepository;
        this._interestRepository = interestRepository;
        this._mapper = mapper;
    }

    public async Task<List<InterestDTO>> GetInterestsByUserIdAsync(long userId) {
        List<Interest> interests = await this._userRepository.GetInterestsByUserIdAsync(userId);
        return this._mapper.Map<List<InterestDTO>>(interests);
    }

    public List<UserDTO> GetUsersByUserIds(StringValues usersIdRaw) {
        if (usersIdRaw.ToString() == string.Empty)
            throw new SonorusAccountAPIException("Informe os IDs dos usuários", 400);

        List<long> userIds = JsonSerializer.Deserialize<List<long>>(usersIdRaw!)!;
        return this._mapper.Map<List<UserDTO>>(this._userRepository.GetUsersByUserIdAsync(userIds));
    }

    public async Task<AuthToken> LoginAsync(UserLoginDTO userLogin) {
        this.Validate<UserLoginValidator, UserLoginDTO>(userLogin);

        User? user = await this._userRepository.GetByLoginAsync(userLogin.Email ?? userLogin.Nickname!) ?? throw new SonorusAccountAPIException("Apelido/e-mail e senha não coincidem", 404);

        if (!Verify(userLogin.Password, user.Password))
            throw new SonorusAccountAPIException("Apelido/e-mail e senha não coincidem", 404);

        AuthToken authToken = new() {
            AccessToken = this._tokenService.GenerateToken(user),
            RefreshToken = this._tokenService.GenerateRefreshToken()
        };

        await this._refreshTokenRepository.SaveRefreshTokenAsync((long)user.UserId!, authToken.RefreshToken);
        return authToken;
    }

    public async Task<AuthToken> RefreshTokenAsync(long userId, string refreshToken) {
        string savedRefreshToken = await this._refreshTokenRepository.GetRefreshTokenByUserIdAsync(userId);

        if (savedRefreshToken != refreshToken)
            throw new SonorusAccountAPIException("Nenhum refresh token encontrado à este usuário", 404);

        User user = await this._userRepository.GetByUserIdAsync(userId);
        string newJwtToken = this._tokenService.GenerateToken(user);
        string newRefreshToken = this._tokenService.GenerateRefreshToken();
        await this._refreshTokenRepository.DeleteRefreshTokenAsync((long)user.UserId!, refreshToken);
        await this._refreshTokenRepository.SaveRefreshTokenAsync((long)user.UserId!, newRefreshToken);

        return new() {
            AccessToken = newJwtToken,
            RefreshToken = newRefreshToken
        };
    }

    public async Task<AuthToken> RegisterAsync(UserRegisterDTO userRegister) {
        this.Validate<UserRegisterValidator, UserRegisterDTO>(userRegister);

        User mappedUser = this._mapper.Map<User>(userRegister);
        await this._userRepository.RegisterAsync(mappedUser);

        AuthToken authToken = new() {
            AccessToken = this._tokenService.GenerateToken(mappedUser),
            RefreshToken = this._tokenService.GenerateRefreshToken()
        };

        await this._refreshTokenRepository.SaveRefreshTokenAsync((long)mappedUser.UserId!, authToken.RefreshToken);
        return authToken;
    }

    public async Task SaveInterestsByUserIdAsync(long userId, List<InterestDTO> interests) {
        this.Validate<UserInterestsValidator, UserInterestsDTO>(new UserInterestsDTO() { UserId = userId, Interests = interests });

        List<Interest> interestsMapped = this._mapper.Map<List<Interest>>(interests);

        foreach (Interest interest in interestsMapped)
            interest.InterestId ??= await this._interestRepository.CreateAsync(interest);

        await this._userRepository.SaveInterestsByUserIdAsync(userId, interestsMapped);
    }

    public async Task SavePictureByUserIdAsync(long userId, IFormFile picture) {
        string pictureName = Guid.NewGuid().ToString() + Path.GetExtension(picture.FileName);
        BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, pictureName);
        await blobClient.UploadAsync(picture.OpenReadStream());
        await this._userRepository.SavePictureByUserIdAsync(userId, pictureName);
    }
}