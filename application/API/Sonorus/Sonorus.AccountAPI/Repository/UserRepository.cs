using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Data;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Repository.Interfaces;

namespace Sonorus.AccountAPI.Repository;

public class UserRepository : IUserRepository {
    private readonly SonorusDbContext _dbContext;

    public UserRepository(SonorusDbContext dbContext) => this._dbContext = dbContext;

    public async Task<User?> Login(string email, string nickname, string password) {
        return await this._dbContext.Users.FirstOrDefaultAsync(user => user.Email == email || user.Nickname == nickname && user.Password == password);
    }

    public async Task Register(User user) {
        await this._dbContext.Users.AddAsync(user);
        await this._dbContext.SaveChangesAsync();
    }
}