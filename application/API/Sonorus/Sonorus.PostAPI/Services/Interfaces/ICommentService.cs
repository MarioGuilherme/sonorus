using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Services.Interfaces;

public interface ICommentService {
    Task<List<CommentDTO>> GetAllByPostIdAsync(long postId, CurrentUser user);

    Task<long> LikeByCommentIdAsync(long commentId, long userId);

    Task<CommentDTO> SaveCommentAsync(long userId, NewCommentDTO newComment);

    Task DeleteCommentById(long userId, long commentId);

    Task UpdateCommentById(long userId, long postId, string newContent);
}