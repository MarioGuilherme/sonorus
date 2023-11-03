using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using Sonorus.PostAPI.Data.Context;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Repository.Interfaces;

namespace Sonorus.PostAPI.Repository;

public class PostRepository : IPostRepository {
    private readonly PostAPIDbContext _dbContext;

    public PostRepository(PostAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<List<Post>> GetAllAsync(List<long> idsInterests, bool contentByPreference) {
        if (contentByPreference)
            return await this._dbContext.Posts
                .AsNoTracking()
                .Include(post => post.Medias)
                .Include(post => post.Interests)
                .Include(post => post.Likers)
                .Include(post => post.Comments)
                .Where(post => post.Interests.Any(interest => idsInterests.Contains(interest.InterestId)))
                .ToListAsync();

        return await this._dbContext.Posts
            .AsNoTracking()
            .Include(post => post.Medias)
            .Include(post => post.Interests)
            .Include(post => post.Likers)
            .Include(post => post.Comments)
            .ToListAsync();
    }

    public async Task<long> LikeByPostIdAsync(long postId, long userId) {
        Post post = await this._dbContext.Posts
            .Include(post => post.Likers)
            .FirstAsync(post => post.PostId == postId);
        PostLiker? postLiker = post.Likers.FirstOrDefault(post => post.UserId == userId);

        if (postLiker is not null)
            this._dbContext.PostLikers.Remove(postLiker);
        else
            post.Likers.Add(new() { UserId = userId });

        await this._dbContext.SaveChangesAsync();

        return post.Likers.Count;
    }
}