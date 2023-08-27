using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Data;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Repository.Interfaces;

namespace Sonorus.AccountAPI.Repository;

public class UserRepository : IUserRepository {
    private readonly AccountAPIDbContext _dbContext;

    public UserRepository(AccountAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<User?> Login(string login) => await this._dbContext.Users.FirstOrDefaultAsync(user => user.Email == login || user.Nickname == login);

    public async Task Register(User user) {
        await this._dbContext.Users.AddAsync(user);
        await this._dbContext.SaveChangesAsync();
    }

    public async Task SaveInterests(long idUser, List<Interest> interests) {
        User user = await this._dbContext.Users
            .Include(user => user.Interests)
            .FirstAsync(user => user.IdUser == idUser);

        foreach (Interest interest in interests) {
            Interest interestDB = await this._dbContext.Interests.FirstAsync(i => i.IdInterest == interest.IdInterest);
            user.Interests.Add(interestDB);
        }

        await this._dbContext.SaveChangesAsync();
    }

    public async Task<long> CreateInterest(Interest interest) {
        await this._dbContext.Interests.AddAsync(interest);
        await this._dbContext.SaveChangesAsync();
        return (long) interest.IdInterest!;
    }

    public async Task SavePicture(long idUser, string pictureName) {
        User user = await this._dbContext.Users.FirstAsync(user => user.IdUser == idUser);
        user.Picture = pictureName;
        await this._dbContext.SaveChangesAsync();
    }
}