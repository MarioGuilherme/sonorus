using AutoMapper;
using Azure.Storage.Blobs;
using Sonorus.AccountAPI.Core;
using Sonorus.AccountAPI.Data.Entities;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Services.Interfaces;
using Sonorus.AccountAPI.Services.Validator;
using System.IdentityModel.Tokens.Jwt;
using static BCrypt.Net.BCrypt;

namespace Sonorus.AccountAPI.Services;

public class UserService : BaseService, IUserService {
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly TokenService _tokenService;
    private readonly IUserRepository _userRepository;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IInterestRepository _interestRepository;
    private readonly IMapper _mapper;

    public UserService(
        IHttpClientFactory httpClientFactory,
        TokenService tokenService,
        IUserRepository userRepository,
        IRefreshTokenRepository refreshTokenRepository,
        IInterestRepository interestRepository,
        IMapper mapper
    ) {
        this._httpClientFactory = httpClientFactory;
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

    public async Task<List<UserDTO>> GetUsersByUserIdsAsync(List<long> userIds) {
        if (!userIds.Any())
            throw new SonorusAccountAPIException("Informe os IDs dos usuários", 400);

        return this._mapper.Map<List<UserDTO>>(await this._userRepository.GetUsersByUserIdAsync(userIds));
    }

    public async Task UpdatePassword(long userId, string newPassword) => await this._userRepository.UpdatePassword(userId, newPassword);

    public async Task DeleteMyAccount(long userId, string accessToken) {
        string? pictureName = await this._userRepository.DeleteMyAccount(userId);

        if (pictureName is not null) {
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, pictureName);
            await blobClient.DeleteAsync();
        }

        HttpClient postMShttpClient = this._httpClientFactory.CreateClient("PostAPI");
        HttpClient businessMShttpClient = this._httpClientFactory.CreateClient("BusinessAPI");
        HttpClient marketplaceMShttpClient = this._httpClientFactory.CreateClient("MarketplaceAPI");

        postMShttpClient.DefaultRequestHeaders.Add("Authorization", accessToken);
        businessMShttpClient.DefaultRequestHeaders.Add("Authorization", accessToken);
        marketplaceMShttpClient.DefaultRequestHeaders.Add("Authorization", accessToken);

        await postMShttpClient.DeleteAsync($"api/v1/posts");
        await businessMShttpClient.DeleteAsync($"api/v1/opportunities");
        await marketplaceMShttpClient.DeleteAsync($"api/v1/products");
    }

    public async Task<CompleteUserDTO> GetCompleteUserByIdAsync(long userId) {
        HttpClient postMShttpClient = this._httpClientFactory.CreateClient("PostAPI");
        HttpClient businessMShttpClient = this._httpClientFactory.CreateClient("BusinessAPI");
        HttpClient marketplaceMShttpClient = this._httpClientFactory.CreateClient("MarketplaceAPI");

        User? user = await this._userRepository.GetCompleteUserByIdAsync(userId) ?? throw new SonorusAccountAPIException("Usuário não encontrado", 404);

        CompleteUserDTO mappedUser = this._mapper.Map<CompleteUserDTO>(user);

        mappedUser.Posts = (await postMShttpClient.GetFromJsonAsync<RestResponse<List<PostDTO>>>($"api/v1/users/{userId}/posts"))!.Data!;
        mappedUser.Products = (await marketplaceMShttpClient.GetFromJsonAsync<RestResponse<List<ProductDTO>>>($"api/v1/users/{userId}/products"))!.Data!;
        mappedUser.Opportunities = (await businessMShttpClient.GetFromJsonAsync<RestResponse<List<OpportunityDTO>>>($"api/v1/users/{userId}/opportunities"))!.Data!;

        return mappedUser;
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

    public async Task<AuthToken> RefreshTokenAsync(AuthToken authToken) {
        int userId = int.Parse(new JwtSecurityToken(authToken.AccessToken.ToString().Split(' ').Last()).Claims.First(c => c.Type == "UserId").Value);

        string savedRefreshToken = await this._refreshTokenRepository.GetRefreshTokenByUserIdAsync(userId);

        if (savedRefreshToken != authToken.RefreshToken)
            throw new SonorusAccountAPIException("Nenhum refresh token encontrado à este usuário", 404);

        User user = await this._userRepository.GetByUserIdAsync(userId);
        string newJwtToken = this._tokenService.GenerateToken(user);
        string newRefreshToken = this._tokenService.GenerateRefreshToken();
        await this._refreshTokenRepository.DeleteRefreshTokenAsync((long)user.UserId!, authToken.RefreshToken);
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

        foreach (Interest interest in interestsMapped) {
            if (interest.InterestId == null) {
                interest.InterestId = await this._interestRepository.CreateAsync(interest);
                HttpClient postMShttpClient = this._httpClientFactory.CreateClient("PostAPI");
                await postMShttpClient.PostAsync("api/v1/interestsPost/", new StringContent(userId.ToString()));
            }
        }

        await this._userRepository.SaveInterestsByUserIdAsync(userId, interestsMapped);
    }

    public async Task<string> SavePictureByUserIdAsync(long userId, IFormFile picture) {
        string pictureName = Guid.NewGuid().ToString() + Path.GetExtension(picture.FileName);
        BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, pictureName);
        await blobClient.UploadAsync(picture.OpenReadStream());
        await this._userRepository.SavePictureByUserIdAsync(userId, pictureName);
        return $"{Environment.GetEnvironmentVariable("StorageBaseURL")}{Environment.GetEnvironmentVariable("StorageContainer")}/{pictureName}";
    }

    public async Task AddInterest(long userId, long idInterest) => await this._userRepository.AddInterest(userId, idInterest);

    public async Task RemoveInterest(long userId, long idInterest) => await this._userRepository.RemoveInterest(userId, idInterest);

    public async Task UpdateUser(long userId, UserRegisterDTO user) => await this._userRepository.UpdateAsync(userId, user.FullName!, user.Nickname!, user.Email!);
}