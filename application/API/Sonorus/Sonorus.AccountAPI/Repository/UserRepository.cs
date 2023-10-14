using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Data.Context;
using Sonorus.AccountAPI.Data.Entities;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Repository.Interfaces;

namespace Sonorus.AccountAPI.Repository;

public class UserRepository : IUserRepository {
    private readonly AccountAPIDbContext _dbContext;

    public UserRepository(AccountAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<User?> Login(string login) => await this._dbContext.Users.FirstOrDefaultAsync(user => user.Email == login || user.Nickname == login);

    public async Task Register(User user) {
        bool emailOrNicknameInUse = await this._dbContext.Users.AnyAsync(userDB => userDB.Email.ToUpper() == user.Email.ToUpper() || userDB.Nickname.ToUpper() == user.Nickname.ToUpper());

        if (emailOrNicknameInUse) throw new SonorusAccountAPIException("Este e-mail ou apelido já está sendo utilizado", 409);

        await this._dbContext.Users.AddAsync(user);
        await this._dbContext.SaveChangesAsync();
    }

    public async Task SaveInterests(long idUser, List<Interest> interests) {
        User user = await this._dbContext.Users
            .Include(user => user.Interests)
            .FirstAsync(user => user.UserId == idUser);

        foreach (Interest interest in interests) {
            Interest interestDB = await this._dbContext.Interests.FirstAsync(i => i.InterestId == interest.InterestId);
            user.Interests.Add(interestDB);
        }

        await this._dbContext.SaveChangesAsync();
    }

    public async Task<long> CreateInterest(Interest interest) {
        await this._dbContext.Interests.AddAsync(interest);
        await this._dbContext.SaveChangesAsync();
        return (long) interest.InterestId!;
    }

    public async Task SavePicture(long idUser, string pictureName) {
        User user = await this._dbContext.Users.FirstAsync(user => user.UserId == idUser);
        user.Picture = pictureName;
        await this._dbContext.SaveChangesAsync();
    }

    public async Task<List<Interest>> GetInterests(long userId) =>
        (await this._dbContext.Users
            .AsNoTracking()
            .Include(user => user.Interests
        ).FirstAsync(user => user.UserId == userId)).Interests.ToList();

    public List<User> GetUsersById(List<long> idsUser) => this._dbContext.Users
        .AsNoTracking()
        .Where(user => idsUser.Contains(user.UserId!.Value!))
        .ToList();
}