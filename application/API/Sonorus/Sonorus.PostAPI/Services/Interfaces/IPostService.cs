using Microsoft.Extensions.Primitives;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Services.Interfaces;

public interface IPostService {
    Task<List<PostDTO>> GetAllAsync(CurrentUser user, StringValues contentByPreferenceRaw);
    Task<long> LikeByPostIdAsync(long postId, long userId);
}