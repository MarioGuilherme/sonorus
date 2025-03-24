using Sonorus.Account.Core.Entities;

namespace Sonorus.Account.Core.Repositories;

public interface IUserRepository {
    void Delete(User user);
    Task<bool> EmailInUseInAsync(string email, long userId = 0);
    Task<User?> GetByIdAsync(long userId);
    Task<User?> GetByIdTrackingAsync(long userId);
    Task<User?> GetByLoginAsync(string login);
    Task<List<User>> GetUsersByIdsAsync(IEnumerable<long> userIds);
    Task RegisterAsync(User user);
    Task<bool> NicknameIsInUseAsync(string nickname, long userId = 0);
}