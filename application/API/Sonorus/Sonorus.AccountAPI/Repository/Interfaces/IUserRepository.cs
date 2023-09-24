using Sonorus.AccountAPI.Data;

namespace Sonorus.AccountAPI.Repository.Interfaces;

public interface IUserRepository {
    Task<User?> Login(string login);
    Task Register(User user);
    Task SaveInterests(long userId, List<Interest> interests);
    Task<long> CreateInterest(Interest interest);
    Task SavePicture(long idUser, string pictureName);
}