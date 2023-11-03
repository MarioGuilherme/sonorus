using Sonorus.AccountAPI.Data.Entities;

namespace Sonorus.AccountAPI.Repository.Interfaces;

public interface IUserRepository {
    Task<User?> GetByLoginAsync(string login);
    Task<User> GetByUserIdAsync(long userId);
    Task<List<Interest>> GetInterestsByUserIdAsync(long userId);
    List<User> GetUsersByUserIdAsync(List<long> idsUser);
    Task RegisterAsync(User user);
    Task SaveInterestsByUserIdAsync(long userId, List<Interest> interests);
    Task SavePictureByUserIdAsync(long userId, string pictureName);
    Task UpdateAsync(User user);
}