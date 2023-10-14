using Sonorus.PostAPI.Data.Entities;

namespace Sonorus.PostAPI.Repository.Interfaces;

public interface IPostRepository {
    Task<List<Post>> GetAllAsync(List<long> idsInterests);
    Task<List<Comment>> GetAllCommentsByPostAsync(long postId);
    Task<long> LikeAsync(long idUser, long idPost);
    Task<long> LikeCommentByIdAsync(long userId, long commentId);
}