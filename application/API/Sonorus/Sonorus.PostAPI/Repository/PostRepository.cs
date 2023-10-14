using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Hosting;
using Sonorus.PostAPI.Data.Context;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Repository.Interfaces;

namespace Sonorus.PostAPI.Repository;

public class PostRepository : IPostRepository {
    private readonly PostAPIDbContext _dbContext;

    public PostRepository(PostAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<List<Post>> GetAllAsync(List<long> idsInterests) {
        return await this._dbContext.Posts
            .AsNoTracking()
            .Include(post => post.Medias)
            .Include(post => post.Interests)
            .Include(post => post.Likers)
            .Include(post => post.Comments)
            .Where(post => post.Interests.Any(interest => idsInterests.Contains(interest.InterestId)))
            .ToListAsync();
    }

    public async Task<List<Comment>> GetAllCommentsByPostAsync(long postId) => (await this._dbContext.Posts
        .AsNoTracking()
        .Include(post => post.Comments)
        .ThenInclude(comment => comment.Likers)
        .FirstAsync(p => p.PostId == postId)
    ).Comments.ToList();

    public async Task<long> LikeAsync(long userId, long postId) {
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

    public async Task<long> LikeCommentByIdAsync(long userId, long commentId) {
        Comment comment = await this._dbContext.Comments
            .Include(comment => comment.Likers)
            .FirstAsync(comment => comment.CommentId == commentId);
        CommentLiker? commentLiker = comment.Likers.FirstOrDefault(comment => comment.UserId == userId);

        if (commentLiker is not null)
            this._dbContext.CommentLikers.Remove(commentLiker);
        else
            comment.Likers.Add(new() { UserId = userId });

        await this._dbContext.SaveChangesAsync();

        return comment.Likers.Count;
    }
}