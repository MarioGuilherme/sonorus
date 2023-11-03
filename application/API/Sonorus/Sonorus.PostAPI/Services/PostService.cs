using AutoMapper;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Repository.Interfaces;
using Sonorus.PostAPI.Services.Interfaces;
using System.Net.Http.Headers;
using System.Text.Json;
using Microsoft.Extensions.Primitives;

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

    public async Task<List<PostDTO>> GetAllAsync(CurrentUser user, StringValues contentByPreferenceRaw) {
        bool contentByPreference = contentByPreferenceRaw.ToString() != string.Empty && bool.Parse(contentByPreferenceRaw!);

        this._httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", user.Token);
        HttpResponseMessage? response = await this._httpClient.GetAsync("api/v1/users/interests");

        if (!response.IsSuccessStatusCode)
            throw new ArgumentException($"Something went wrong when calling the API : {response.ReasonPhrase}");

        RestResponse<List<InterestDTO>> restResponse = JsonSerializer.Deserialize<RestResponse<List<InterestDTO>>>(
            await response.Content.ReadAsStringAsync(),
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
        )!;

        List<Post> posts = await this._postRepository.GetAllAsync(restResponse.Data!.Select(interest => interest.InterestId!.Value).ToList(), contentByPreference);
        List<PostDTO> mappedPosts = new();

        if (!posts.Any())
            return mappedPosts;

        List<long> idsUsers = posts.Select(post => post.UserId).Distinct().ToList();

        this._httpClient.DefaultRequestHeaders.Add("UserIds", JsonSerializer.Serialize(idsUsers));
        HttpResponseMessage? responseUsers = await this._httpClient.GetAsync("api/v1/users/");

        RestResponse<List<UserDTO>> restResponseUsers = JsonSerializer.Deserialize<RestResponse<List<UserDTO>>>(
            await responseUsers!.Content.ReadAsStringAsync(),
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
        )!;

        HttpResponseMessage? restResponseAllInterests = await this._httpClient.GetAsync("api/v1/interests");
        RestResponse<List<InterestDTO>> allInterests = JsonSerializer.Deserialize<RestResponse<List<InterestDTO>>>(
            await restResponseAllInterests!.Content.ReadAsStringAsync(),
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
        )!;

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
            postMapped.Author = restResponseUsers!.Data!.First(user => postMapped.Author.UserId == user.UserId);
            postMapped.Interests.ForEach(interest => {
                InterestDTO interestFromAuthMS = allInterests.Data!.First(interestRest => interestRest. InterestId == interest.InterestId);
                interest.Value = interestFromAuthMS.Value;
                interest.Key = interestFromAuthMS.Key;
            });
        });

        return mappedPosts;
    }

    public async Task<long> LikeByPostIdAsync(long postId, long userId) => await this._postRepository.LikeByPostIdAsync(postId, userId);
}