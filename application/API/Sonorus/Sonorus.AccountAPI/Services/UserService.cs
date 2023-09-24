using AutoMapper;
using Azure.Storage.Blobs;
using Sonorus.AccountAPI.Core;
using Sonorus.AccountAPI.Data;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Services.Interfaces;
using Sonorus.AccountAPI.Services.Validator;
using static BCrypt.Net.BCrypt;

namespace Sonorus.AccountAPI.Services;

public class UserService : BaseService, IUserService {
    private readonly TokenService _tokenService;
    private readonly IUserRepository _userRepository;
    private readonly IMapper _mapper;

    public UserService(
        TokenService tokenService,
        IUserRepository userRepository,
        IMapper mapper
    ) {
        this._tokenService = tokenService;
        this._userRepository = userRepository;
        this._mapper = mapper;
    }

    public async Task<AuthToken> Login(UserLoginDTO userLogin) {
        this.Validate<UserLoginValidator, UserLoginDTO>(userLogin);

        User user = await this._userRepository.Login(userLogin.Email ?? userLogin.Nickname!) ??
            throw new SonorusAccountAPIException("Apelido/e-mail e senha não coincidem", 404);

        if (!Verify(userLogin.Password, user.Password))
            throw new SonorusAccountAPIException("Apelido/e-mail e senha não coincidem", 404);

        return new() {
            AccessToken = this._tokenService.GenerateToken(user)
        };
    }

    public async Task<AuthToken> Register(UserRegisterDTO userRegister) {
        this.Validate<UserRegisterValidator, UserRegisterDTO>(userRegister);

        User user = this._mapper.Map<User>(userRegister);
        await this._userRepository.Register(user);

        return new() {
            AccessToken = this._tokenService.GenerateToken(user),
            RefreshToken = ""
        };
    }

    public async Task SaveInterests(long idUser, List<InterestDTO> interests) {
        this.Validate<UserInterestsValidator, UserInterestsDTO>(new UserInterestsDTO() { IdUser = idUser, Interests = interests });

        List<Interest> interestsMapped = this._mapper.Map<List<Interest>>(interests);

        foreach (Interest interest in interestsMapped)
            interest.IdInterest ??= await this._userRepository.CreateInterest(interest);

        await this._userRepository.SaveInterests(idUser, interestsMapped);
    }

    public async Task SavePicture(long idUser, IFormFile picture) {
        string pictureName = Guid.NewGuid().ToString() + Path.GetExtension(picture.FileName);
        BlobClient blobClient = new(Environment.GetEnvironmentVariable("ConnectionStringBlobStorage")!, "pictures-user", pictureName);
        await blobClient.UploadAsync(picture.OpenReadStream());
        await this._userRepository.SavePicture(idUser, pictureName);
    }
}