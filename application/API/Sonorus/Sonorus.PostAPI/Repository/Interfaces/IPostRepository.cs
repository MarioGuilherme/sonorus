using Sonorus.PostAPI.Data.Entities;

namespace Sonorus.PostAPI.Repository.Interfaces;

public interface IPostRepository {
    Task<List<Post>> GetMoreEightPostsAsync(int offset, List<long> idsInterests, bool contentByPreference);
    
    Task<List<Post>> GetAllPostByUserId(long userid);

    Task<long> LikeByPostIdAsync(long postId, long userId);

    Task<List<string>> UpdatePostAsync(Post postForm, List<long> interestsIds, List<string> mediasName, List<string> mediasToKeep);

    Task CreatePostAsync(Post post, List<long> interestsIds, List<string> mediasName);

    Task<List<string>> DeleteAllFromUserId(long userId);

    Task DeleteByPostIdAsync(long userId, long postId);

    Task InsertInterestId(long interestId);
}