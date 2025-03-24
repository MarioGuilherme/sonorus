using Microsoft.EntityFrameworkCore;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Repositories;

namespace Sonorus.Account.Infrastructure.Persistence.Repositories;

public class UserRepository(SonorusAccountDbContext dbContext) : IUserRepository {
    private readonly SonorusAccountDbContext _dbContext = dbContext;

    public void Delete(User user) {
        user.Interests.Clear();
        this._dbContext.Users.Remove(user);
    }

    public Task<bool> EmailInUseInAsync(string email, long userId = 0) => this._dbContext.Users
        .AnyAsync(userDb => userDb.Email.ToUpper() == email.ToUpper() && userDb.UserId != userId);

    public Task<User?> GetByIdAsync(long userId) => this._dbContext.Users
        .AsNoTracking()
        .FirstOrDefaultAsync(user => user.UserId == userId);

    public Task<User?> GetByIdTrackingAsync(long userId) => this._dbContext.Users
        .Include(user => user.Interests)
        .Include(user => user.RefreshToken)
        .FirstOrDefaultAsync(user => user.UserId == userId);

    public Task<User?> GetByLoginAsync(string login) => this._dbContext.Users
        .AsNoTracking()
        .FirstOrDefaultAsync(user => user.Email == login || user.Nickname == login);

    public Task<List<User>> GetUsersByIdsAsync(IEnumerable<long> userIds) => this._dbContext.Users
        .AsNoTracking()
        .Where(user => userIds.Contains(user.UserId))
        .ToListAsync();

    public async Task RegisterAsync(User user) {
        await this._dbContext.Users.AddAsync(user);
    }

    public Task<bool> NicknameIsInUseAsync(string nickname, long userId = 0) => this._dbContext.Users.AnyAsync(userDb => userDb.Nickname.ToUpper() == nickname.ToUpper() && userDb.UserId != userId);
}