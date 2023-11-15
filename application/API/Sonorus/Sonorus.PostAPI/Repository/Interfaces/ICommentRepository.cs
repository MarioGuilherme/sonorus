using Sonorus.PostAPI.Data.Entities;

namespace Sonorus.PostAPI.Repository.Interfaces;

public interface ICommentRepository {
    Task<List<Comment>> GetAllByPostIdAsync(long postId);

    Task<long> LikeByCommentIdAsync(long commentId, long userId);

    Task<Comment> SaveCommentAsync(long postId, Comment comment);

    Task DeleteCommentById(long userId, long commentId);

    Task UpdateCommentByIdAsync(long userId, long commentId, string newComment);
}