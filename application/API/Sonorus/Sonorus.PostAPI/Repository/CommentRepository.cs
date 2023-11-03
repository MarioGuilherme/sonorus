using Microsoft.EntityFrameworkCore;
using Sonorus.PostAPI.Data.Context;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Repository.Interfaces;

namespace Sonorus.PostAPI.Repository;

public class CommentRepository : ICommentRepository {
    private readonly PostAPIDbContext _dbContext;

    public CommentRepository(PostAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<List<Comment>> GetAllByPostIdAsync(long postId) => (
        await this._dbContext.Posts
            .AsNoTracking()
            .Include(post => post.Comments)
            .ThenInclude(comment => comment.Likers)
            .FirstAsync(p => p.PostId == postId)
    ).Comments.ToList();

    public async Task<long> LikeByCommentIdAsync(long commentId, long userId) {
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


    public async Task<long> SaveCommentAsync(Comment comment) {
        await this._dbContext.Comments.AddAsync(comment);
        await this._dbContext.SaveChangesAsync();
        return (long)comment.CommentId!;
    }
}