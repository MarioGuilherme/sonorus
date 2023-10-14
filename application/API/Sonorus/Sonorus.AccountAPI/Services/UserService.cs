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

        user.Picture = user.Picture is null
            ? "https://mgaroteste1.blob.core.windows.net/pictures-user/defaultPicture.png"
            : "https://mgaroteste1.blob.core.windows.net/pictures-user/" + user.Picture;

        return new() {
            AccessToken = this._tokenService.GenerateToken(user)
        };
    }

    public async Task<AuthToken> Register(UserRegisterDTO userRegister) {
        this.Validate<UserRegisterValidator, UserRegisterDTO>(userRegister);

        User user = this._mapper.Map<User>(userRegister);
        await this._userRepository.Register(user);

        user.Picture ??= "https://mgaroteste1.blob.core.windows.net/pictures-user/defaultPicture.png";

        return new() {
            AccessToken = this._tokenService.GenerateToken(user),
            RefreshToken = ""
        };
    }

    public async Task SaveInterests(long idUser, List<InterestDTO> interests) {
        this.Validate<UserInterestsValidator, UserInterestsDTO>(new UserInterestsDTO() { UserId = idUser, Interests = interests });

        List<Interest> interestsMapped = this._mapper.Map<List<Interest>>(interests);

        foreach (Interest interest in interestsMapped)
            interest.InterestId ??= await this._userRepository.CreateInterest(interest);

        await this._userRepository.SaveInterests(idUser, interestsMapped);
    }

    public async Task<List<InterestDTO>> GetInterests(long idUser) {
        List<Interest> interests = await this._userRepository.GetInterests(idUser);
        return this._mapper.Map<List<InterestDTO>>(interests);
    }

    public async Task SavePicture(long idUser, IFormFile picture) {
        string pictureName = Guid.NewGuid().ToString() + Path.GetExtension(picture.FileName);
        BlobClient blobClient = new(Environment.GetEnvironmentVariable("ConnectionStringBlobStorage")!, "pictures-user", pictureName);
        await blobClient.UploadAsync(picture.OpenReadStream());
        await this._userRepository.SavePicture(idUser, pictureName);
    }

    public List<UserDTO> GetUsersById(List<long> idsUser) {
        List<UserDTO> usersMapped = this._mapper.Map<List<UserDTO>>(this._userRepository.GetUsersById(idsUser));
        usersMapped.ForEach(usersMapped => usersMapped.Picture = usersMapped.Picture is null
            ? "https://mgaroteste1.blob.core.windows.net/pictures-user/defaultPicture.png"
            : "https://mgaroteste1.blob.core.windows.net/pictures-user/" + usersMapped.Picture
        );
        return usersMapped;
    }
}