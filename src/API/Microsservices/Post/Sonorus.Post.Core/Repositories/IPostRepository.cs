using Sonorus.Post.Core.Entities;

namespace Sonorus.Post.Core.Repositories;

public interface IPostRepository {
    Task CreatePostAsync(Entities.Post post);
    void Delete(Entities.Post post);
    IEnumerable<string> DeleteAllFromUserId(long userId);
    void DeleteCommentFromPost(Entities.Post post, Comment comment);
    Task<List<Comment>?> GetAllCommentsByPostIdAsync(long postId);
    Task<Entities.Post?> GetByIdWithFullDataTrackingAsync(long postId);
    Task<Entities.Post?> GetByIdWithPostLikersTrackingAsync(long postId);
    Task<List<Entities.Post>> GetPagedPostsAsync(int offset, int limit, IEnumerable<long>? interestsIds = default);
    Task<long> GetTotalLikersOfCommentIdAsync(long commentId);
    void UpdatePost(Entities.Post postForm, IEnumerable<Media> mediasToRemove);
}