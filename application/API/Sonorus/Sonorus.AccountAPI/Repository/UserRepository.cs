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

    public async Task<User?> GetCompleteUserByIdAsync(long userId) => await this._dbContext.Users
        .AsNoTracking()
        .Include(user => user.Interests)
        .FirstOrDefaultAsync(user => user.UserId == userId);

    public Task<List<User>> GetUsersByUserIdAsync(List<long> userIds) => this._dbContext.Users
        .AsNoTracking()
        .Where(user => userIds.Contains(user.UserId!.Value!))
        .ToListAsync();

    public async Task RegisterAsync(User user) {
        bool emailOrNicknameInUse = await this._dbContext.Users.AnyAsync(userDB => userDB.Email.ToUpper() == user.Email.ToUpper() || userDB.Nickname.ToUpper() == user.Nickname.ToUpper());

        if (emailOrNicknameInUse)
            throw new SonorusAccountAPIException("Este e-mail ou apelido já está sendo utilizado", 409);

        await this._dbContext.Users.AddAsync(user);
        await this._dbContext.SaveChangesAsync();
    }
    public async Task<string?> DeleteMyAccount(long userId) {
        User user = await this._dbContext.Users.FirstAsync(user => user.UserId == userId);
        string? oldPicturePath = user.Picture;

        foreach (Interest interest in user.Interests) {
            Interest interestDB = await this._dbContext.Interests.FirstAsync(i => i.InterestId == interest.InterestId);
            user.Interests.Remove(interestDB);
        }

        this._dbContext.RefreshTokens.RemoveRange(this._dbContext.RefreshTokens.Where(rt => rt.UserId == userId));
        this._dbContext.Users.Remove(user);

        await this._dbContext.SaveChangesAsync();

        return oldPicturePath;
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

    public async Task UpdateAsync(long userId, string fullname, string nickname, string email) {
        User? userDb = await this._dbContext.Users.FirstAsync(u => u.UserId == userId);
        userDb.Fullname = fullname;
        userDb.Email = email;
        userDb.Nickname = nickname;
        await this._dbContext.SaveChangesAsync();
    }

    public async Task UpdatePassword(long userId, string newPassword) {
        User userDB = await this._dbContext.Users.FirstAsync(user => user.UserId == userId);
        userDB.Password = newPassword;
        await this._dbContext.SaveChangesAsync();
    }

    public async Task AddInterest(long userId, long idInterest) {
        User user = await this._dbContext.Users
            .Include(user => user.Interests)
            .FirstAsync(user => user.UserId == userId);

        user.Interests.Add(await this._dbContext.Interests.FirstAsync(interest => interest.InterestId == idInterest));

        await this._dbContext.SaveChangesAsync();
    }

    public async Task RemoveInterest(long userId, long idInterest) {
        User user = await this._dbContext.Users
            .Include(user => user.Interests)
            .FirstAsync(user => user.UserId == userId);

        user.Interests.Remove(await this._dbContext.Interests.FirstAsync(interest => interest.InterestId == idInterest));

        await this._dbContext.SaveChangesAsync();
    }
}