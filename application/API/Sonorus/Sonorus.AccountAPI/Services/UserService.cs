using AutoMapper;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using FluentValidation;
using FluentValidation.Results;
using Sonorus.AccountAPI.Configuration;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Services.Interfaces;
using System.ComponentModel;
using System.IO;
using static BCrypt.Net.BCrypt;

namespace Sonorus.AccountAPI.Services;

public class UserService : IUserService {
    private readonly IUserRepository _userRepository;
    private readonly IMapper _mapper;

    public UserService(IUserRepository userRepository, IMapper mapper) {
        this._userRepository = userRepository;
        this._mapper = mapper;
    }

    public async Task<AuthToken> Login(UserLoginDTO userLogin) {
        ValidationResult result = new UserLoginDTOValidator().Validate(userLogin);

        if (!result.IsValid) 
            throw new AccountAPIException("Alguns campos estão inválidos", 400, result.Errors.Select(error => error.ErrorMessage).ToList());

        User user = await this._userRepository.Login(userLogin.Email ?? userLogin.Nickname!) ??
            throw new AccountAPIException("Apelido/e-mail e senha não coincidem", 404);

        if (!Verify(userLogin.Password, user.Password))
            throw new AccountAPIException("Apelido/e-mail e senha não coincidem", 404);

        return new() {
            AccessToken = TokenService.GenerateToken(user)
        };
    }

    public async Task<AuthToken> Register(UserRegisterDTO userRegister) {
        ValidationResult result = new UserRegisterDTOValidator().Validate(userRegister);

        if (!result.IsValid)
            throw new AccountAPIException("Alguns campos estão inválidos", 400, result.Errors.Select(error => error.ErrorMessage).ToList());

        User user = this._mapper.Map<User>(userRegister);
        await this._userRepository.Register(user);

        return new() {
            AccessToken = TokenService.GenerateToken(user),
            RefreshToken = ""
        };
    }

    public async Task SaveInterests(long idUser, List<InterestDTO> interests) {
        ValidationResult result = new UserInterestsDTOValidator().Validate(new UserInterestsDTO() {
            IdUser = idUser,
            Interests = interests
        });

        if (!result.IsValid)
            throw new AccountAPIException("Alguns campos estão inválidos", 400, result.Errors.Select(error => error.ErrorMessage).ToList());

        List<Interest> interestsMapped = this._mapper.Map<List<Interest>>(interests);

        foreach (Interest interest in interestsMapped)
            interest.IdInterest ??= await this._userRepository.CreateInterest(interest);

        await this._userRepository.SaveInterests(idUser, interestsMapped);
    }

    public async Task SavePicture(long idUser, IFormFile picture) {
        string pictureName = Guid.NewGuid().ToString() + Path.GetExtension(picture.FileName);
        BlobClient blobClient = new ("DefaultEndpointsProtocol=https;AccountName=mgaroteste1;AccountKey=czanEfZHa2oE0tVipe6sRAGg9dU8DV3JlvLWiNvlB2KlizakfsyFk5/S7DjksuMePy4baOQ0uTkw+AStnY+Gkw==;EndpointSuffix=core.windows.net", "pictures-user", pictureName);
        await blobClient.UploadAsync(picture.OpenReadStream());
        await this._userRepository.SavePicture(idUser, pictureName);
    }
}