using Sonorus.AccountAPI.DTO;

namespace Sonorus.AccountAPI.Services.Interfaces;

public interface IUserService {
    Task<UserDTO> Login(string email, string nickname, string password);
    Task<UserDTO> Register(UserDTO user);
}