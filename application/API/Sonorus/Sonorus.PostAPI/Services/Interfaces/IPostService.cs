using Microsoft.Extensions.Primitives;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Services.Interfaces;

public interface IPostService {
    Task<List<PostDTO>> GetMoreEightPostsAsync(CurrentUser user, int offset, bool contentByPreference);

    Task<List<PostDTO>> GetAllPostByUserId(long userid);

    Task<long> LikeByPostIdAsync(long postId, long userId);

    Task CreatePostAsync(long userId, NewPostDTO post, List<IFormFile> medias);

    Task InsertInterestId(long interestId);

    Task UpdatePostAsync(long userId, NewPostDTO post, List<IFormFile> medias);

    Task DeleteAllFromUser(long userId);

    Task DeleteByPostIdAsync(long userId, long postId);
}