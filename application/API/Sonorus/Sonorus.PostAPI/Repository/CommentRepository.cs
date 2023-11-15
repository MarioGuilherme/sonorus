using Microsoft.EntityFrameworkCore;
using Sonorus.PostAPI.Data.Context;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Exceptions;
using Sonorus.PostAPI.Repository.Interfaces;

namespace Sonorus.PostAPI.Repository;

public class CommentRepository : ICommentRepository {
    private readonly PostAPIDbContext _dbContext;

    public CommentRepository(PostAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task DeleteCommentById(long userId,long commentId) {
        Comment comment = await this._dbContext.Comments
            .Include(comment => comment.Likers)
            .FirstAsync(comment => comment.CommentId == commentId);

        if (comment.UserId != userId)
            throw new SonorusPostAPIException("Este comentário não pertence à você", 403);

        this._dbContext.CommentLikers.RemoveRange(comment.Likers);
        this._dbContext.Comments.Remove(comment);
        await this._dbContext.SaveChangesAsync();
    }

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

    public async Task<Comment> SaveCommentAsync(long postId, Comment comment) {
        Post post = await this._dbContext.Posts.FirstAsync(post => post.PostId == postId);
        post.Comments.Add(comment);
        await this._dbContext.SaveChangesAsync();
        return comment;
    }

    public async Task UpdateCommentByIdAsync(long userId, long commentId, string newComment) {
        Comment comment = await this._dbContext.Comments.FirstAsync(comment => comment.CommentId == commentId);
        if (comment.UserId != userId)
            throw new SonorusPostAPIException("Este comentário não pertence à você", 403);
        comment.Content = newComment;
        await this._dbContext.SaveChangesAsync();
    }
}