using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Services.Interfaces;

public interface IPostService {
    Task<List<PostDTO>> GetAll(CurrentUser user);
    Task<List<CommentDTO>> GetAllCommentsByPostAsync(CurrentUser user, long postId);
    Task<long> LikeAsync(long idUser, long idPost);
    Task<long> LikeCommentByIdAsync(long userId, long commentId);
}