using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Data.Context;
using Sonorus.AccountAPI.Data.Entities;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Repository.Interfaces;

namespace Sonorus.AccountAPI.Repository;

public class UserRepository : IUserRepository {
    private readonly AccountAPIDbContext _dbContext;

    public UserRepository(AccountAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<User?> GetByLoginAsync(string login) => await this._dbContext.Users
        .AsNoTracking()
        .FirstOrDefaultAsync(user => user.Email == login || user.Nickname == login);

    public async Task<User> GetByUserIdAsync(long userId) => await this._dbContext.Users
        .AsNoTracking()
        .FirstAsync(user => user.UserId == userId);

    public async Task<List<Interest>> GetInterestsByUserIdAsync(long userId) => (await this._dbContext.Users
        .AsNoTracking()
        .Include(user => user.Interests
    ).FirstAsync(user => user.UserId == userId)).Interests.ToList();

    public List<User> GetUsersByUserIdAsync(List<long> userIds) => this._dbContext.Users
        .AsNoTracking()
        .Where(user => userIds.Contains(user.UserId!.Value!))
        .ToList();

    public async Task RegisterAsync(User user) {
        bool emailOrNicknameInUse = await this._dbContext.Users.AnyAsync(userDB => userDB.Email.ToUpper() == user.Email.ToUpper() || userDB.Nickname.ToUpper() == user.Nickname.ToUpper());

        if (emailOrNicknameInUse) throw new SonorusAccountAPIException("Este e-mail ou apelido já está sendo utilizado", 409);

        await this._dbContext.Users.AddAsync(user);
        await this._dbContext.SaveChangesAsync();
    }

    public async Task SaveInterestsByUserIdAsync(long userId, List<Interest> interests) {
        User user = await this._dbContext.Users
            .Include(user => user.Interests)
            .FirstAsync(user => user.UserId == userId);

        foreach (Interest interest in interests) {
            Interest interestDB = await this._dbContext.Interests.FirstAsync(i => i.InterestId == interest.InterestId);
            user.Interests.Add(interestDB);
        }

        await this._dbContext.SaveChangesAsync();
    }

    public async Task SavePictureByUserIdAsync(long userId, string pictureName) {
        User user = await this._dbContext.Users.FirstAsync(user => user.UserId == userId);
        user.Picture = pictureName;
        await this._dbContext.SaveChangesAsync();
    }

    public async Task UpdateAsync(User user) {
        User? userDb = await this._dbContext.Users.FirstOrDefaultAsync(u => u.UserId == user.UserId);
        userDb.Fullname = user.Fullname;
        userDb.Email = user.Email;
        userDb.Nickname = user.Nickname;
        userDb.Picture = user.Picture;
        await this._dbContext.SaveChangesAsync();
    }
}