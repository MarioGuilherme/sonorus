using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Services.Interfaces;

public interface IUserService {
    Task<List<InterestDTO>> GetInterestsByUserIdAsync(long userId);
    Task<List<UserDTO>> GetUsersByUserIdsAsync(List<long> userIds);
    Task<CompleteUserDTO> GetCompleteUserByIdAsync(long userId);

    Task DeleteMyAccount(long userId, string acessToken);

    Task AddInterest(long userId, long idInterest);

    Task UpdateUser(long userId, UserRegisterDTO user);

    Task RemoveInterest(long userId, long idInterest);

    Task UpdatePassword(long userId, string newPassword);

    Task<AuthToken> LoginAsync(UserLoginDTO userLogin);
    Task<AuthToken> RefreshTokenAsync(AuthToken authToken);
    Task<AuthToken> RegisterAsync(UserRegisterDTO userRegister);
    Task SaveInterestsByUserIdAsync(long userId, List<InterestDTO> interests);
    Task<string> SavePictureByUserIdAsync(long userId, IFormFile picture);
}