using Sonorus.PostAPI.Data.Entities;

namespace Sonorus.PostAPI.Repository.Interfaces;

public interface ICommentRepository {
    Task<List<Comment>> GetAllByPostIdAsync(long postId);
    Task<long> LikeByCommentIdAsync(long commentId, long userId);
    Task<long> SaveCommentAsync(Comment comment);
}