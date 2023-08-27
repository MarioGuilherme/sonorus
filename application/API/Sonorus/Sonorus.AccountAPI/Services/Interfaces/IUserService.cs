using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Services.Interfaces;

public interface IUserService {
    Task<AuthToken> Login(UserLoginDTO userLogin);
    Task<AuthToken> Register(UserRegisterDTO userRegister);
    Task SaveInterests(long idUser, List<InterestDTO> interests);
    Task SavePicture(long idUser, IFormFile picture);
}