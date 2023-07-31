using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Repository.Interfaces;

public interface IUserRepository {
    Task<User?> Login(string email, string nickname, string password);
    Task Register(User user);
}