using Sonorus.PostAPI.Data.Entities;

namespace Sonorus.PostAPI.Repository.Interfaces;

public interface IPostRepository {
    Task<List<Post>> GetAllAsync(List<long> idsInterests, bool contentByPreference);
    Task<long> LikeByPostIdAsync(long postId, long userId);
}