using AutoMapper;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Repository.Interfaces;
using Sonorus.PostAPI.Services.Interfaces;
using System.Net.Http.Headers;
using System.Text.Json;
using Azure.Storage.Blobs;

namespace Sonorus.PostAPI.Services;

public class PostService : IPostService {
    private readonly HttpClient _httpClient;
    private readonly IPostRepository _postRepository;
    private readonly IMapper _mapper;

    public PostService(HttpClient httpClient, IPostRepository postRepository, IMapper mapper) {
        this._httpClient = httpClient;
        this._postRepository = postRepository;
        this._mapper = mapper;
    }

    public async Task<List<PostDTO>> GetMoreEightPostsAsync(CurrentUser user, int offset, bool contentByPreference) {
        this._httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", user.Token);
        RestResponse<List<InterestDTO>> myInterests = (await this._httpClient.GetFromJsonAsync<RestResponse<List<InterestDTO>>>("api/v1/users/interests"))!;

        List<Post> posts = await this._postRepository.GetMoreEightPostsAsync(
            offset,
            myInterests.Data!.Select(interest => interest.InterestId!.Value).ToList(),
            contentByPreference
        );
        List<PostDTO> mappedPosts = new();

        if (!posts.Any())
            return mappedPosts;

        List<long> userIds = posts.Select(post => post.UserId).Distinct().ToList();

        this._httpClient.DefaultRequestHeaders.Clear();
        this._httpClient.DefaultRequestHeaders.Add("userIds", string.Join(",", userIds));
        RestResponse<List<UserDTO>>? authors = (await this._httpClient.GetFromJsonAsync<RestResponse<List<UserDTO>>>("api/v1/users"))!;

        this._httpClient.DefaultRequestHeaders.Clear();
        RestResponse<List<InterestDTO>> allInterests = (await this._httpClient.GetFromJsonAsync<RestResponse<List<InterestDTO>>>("api/v1/interests"))!;

        mappedPosts = this._mapper.Map<List<Post>, List<PostDTO>>(
            posts,
            options => options.AfterMap((posts, postsDTO) => {
                for (int i = 0; i < posts.Count; i++) {
                    postsDTO[i].Author = new() { UserId = posts[i].UserId };
                    postsDTO[i].TotalLikes = posts[i].Likers.Count;
                    postsDTO[i].TotalComments = posts[i].Comments.Count;
                    postsDTO[i].IsLikedByMe = posts[i].Likers.Any(post => post.UserId == user.UserId);
                }
            })
        );

        mappedPosts.ForEach(postMapped => {
            postMapped.Author = authors!.Data!.First(user => postMapped.Author.UserId == user.UserId);
            postMapped.Interests.ForEach(interest => {
                InterestDTO interestFromAuthMS = allInterests.Data!.First(interestRest => interestRest. InterestId == interest.InterestId);
                interest.Value = interestFromAuthMS.Value;
                interest.Key = interestFromAuthMS.Key;
            });
        });

        return mappedPosts;
    }

    public async Task DeleteByPostIdAsync(long userId, long postId) => await this._postRepository.DeleteByPostIdAsync(userId, postId);

    public async Task<long> LikeByPostIdAsync(long postId, long userId) => await this._postRepository.LikeByPostIdAsync(postId, userId);

    public async Task CreatePostAsync(long userId, NewPostDTO post, List<IFormFile> medias) {
        Post mappedPost = this._mapper.Map<Post>(post);
        mappedPost.UserId = userId;
        List<string> mediasName = new();

        foreach (IFormFile file in medias) {
            string mediaName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, mediaName);
            await blobClient.UploadAsync(file.OpenReadStream());
            mediasName.Add(mediaName);
        }

        await this._postRepository.CreatePostAsync(mappedPost, post.InterestsIds, mediasName);
    }

    public async Task UpdatePostAsync(long userId, NewPostDTO post, List<IFormFile> medias) {
        Post mappedPost = this._mapper.Map<Post>(post);
        mappedPost.UserId = userId;
        List<string> mediasName = new();

        foreach (IFormFile file in medias) {
            string mediaName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, mediaName);
            await blobClient.UploadAsync(file.OpenReadStream());
            mediasName.Add(mediaName);
        }
        
        List<string> oldMedias = await this._postRepository.UpdatePostAsync(mappedPost, post.InterestsIds, mediasName, post.MediasToKeep);

        foreach (var item in oldMedias) {
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, item.Split("/")[4]);
            await blobClient.DeleteAsync();
        }
    }

    public async Task DeleteAllFromUser(long userId) {
        List<string> mediasPath = await this._postRepository.DeleteAllFromUserId(userId);

        foreach (var item in mediasPath) {
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, item.Split("/")[4]);
            await blobClient.DeleteAsync();
        }
    }

    public async Task<List<PostDTO>> GetAllPostByUserId(long userId) {
        RestResponse<List<InterestDTO>> allInterests = (await this._httpClient.GetFromJsonAsync<RestResponse<List<InterestDTO>>>("api/v1/interests"))!;
        List<Post> posts = await this._postRepository.GetAllPostByUserId(userId);
        List<PostDTO> mappedPosts = this._mapper.Map<List<PostDTO>>(posts);

        mappedPosts.ForEach(postMapped => {
            postMapped.Interests.ForEach(interest => {
                InterestDTO interestFromAuthMS = allInterests.Data!.First(interestRest => interestRest.InterestId == interest.InterestId);
                interest.Value = interestFromAuthMS.Value;
                interest.Key = interestFromAuthMS.Key;
            });
        });

        return mappedPosts;
    }

    public Task InsertInterestId(long interestId) => this._postRepository.InsertInterestId(interestId);
}