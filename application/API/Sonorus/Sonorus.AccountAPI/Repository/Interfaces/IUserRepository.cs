using Sonorus.AccountAPI.Data.Entities;

namespace Sonorus.AccountAPI.Repository.Interfaces;

public interface IUserRepository {
    Task<User?> GetByLoginAsync(string login);

    Task<User> GetByUserIdAsync(long userId);

    Task<string?> DeleteMyAccount(long userId);

    Task<List<Interest>> GetInterestsByUserIdAsync(long userId);

    Task<List<User>> GetUsersByUserIdAsync(List<long> userIds);

    Task<User?> GetCompleteUserByIdAsync(long userIds);

    Task RegisterAsync(User user);

    Task AddInterest(long userId, long idInterest);

    Task RemoveInterest(long userId, long idInterest);

    Task UpdatePassword(long userId, string newPassword);

    Task SaveInterestsByUserIdAsync(long userId, List<Interest> interests);

    Task SavePictureByUserIdAsync(long userId, string pictureName);

    Task UpdateAsync(long userId, string fullname, string nickname, string email);
}