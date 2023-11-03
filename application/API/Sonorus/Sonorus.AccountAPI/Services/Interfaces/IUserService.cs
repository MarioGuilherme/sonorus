using Microsoft.Extensions.Primitives;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Services.Interfaces;

public interface IUserService {
    Task<List<InterestDTO>> GetInterestsByUserIdAsync(long userId);
    List<UserDTO> GetUsersByUserIds(StringValues userIdsRaw);
    Task<AuthToken> LoginAsync(UserLoginDTO userLogin);
    Task<AuthToken> RefreshTokenAsync(long userId, string refreshToken);
    Task<AuthToken> RegisterAsync(UserRegisterDTO userRegister);
    Task SaveInterestsByUserIdAsync(long userId, List<InterestDTO> interests);
    Task SavePictureByUserIdAsync(long userId, IFormFile picture);
}