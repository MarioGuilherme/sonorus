using AutoMapper;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Repository.Interfaces;
using Sonorus.PostAPI.Services.Interfaces;
using System.Net.Http.Headers;
using System.Text.Json;

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

    public async Task<List<PostDTO>> GetAll(CurrentUser user) {
        this._httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", user.Token);
        HttpResponseMessage? response = await this._httpClient.GetAsync("api/v1/users/interests");

        if (!response.IsSuccessStatusCode)
            throw new ArgumentException($"Something went wrong when calling the API : {response.ReasonPhrase}");

        RestResponse<List<InterestDTO>> restResponse = JsonSerializer.Deserialize<RestResponse<List<InterestDTO>>>(
            await response.Content.ReadAsStringAsync(),
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
        )!;

        List<Post> posts = await this._postRepository.GetAllAsync(restResponse.Data!.Select(interest => interest.InterestId!.Value).ToList());
        List<long> idsUsers = posts.Select(post => post.UserId).Distinct().ToList();

        HttpResponseMessage? responseUsers = await this._httpClient.PostAsJsonAsync("api/v1/users/", idsUsers);

        RestResponse<List<UserDTO>> restResponseUsers = JsonSerializer.Deserialize<RestResponse<List<UserDTO>>>(
            await responseUsers.Content.ReadAsStringAsync(),
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
        )!;

        List<PostDTO> mappedPosts = this._mapper.Map<List<Post>, List <PostDTO>>(
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
            postMapped.Author = restResponseUsers.Data!.First(user => postMapped.Author.UserId == user.UserId);
            postMapped.Interests.ForEach(interest => {
                InterestDTO interestFromAuthMS = restResponse.Data!.First(interest => interest.InterestId == interest.InterestId);
                interest.Value = interestFromAuthMS.Value;
                interest.Key = interestFromAuthMS.Key;
            });
            postMapped.Medias.ForEach(media => media.Path = $"https://mgaroteste1.blob.core.windows.net/posts-medias/{media.Path}");
        });
        return mappedPosts;
    }

    public async Task<long> LikeAsync(long idUser, long idPost) => await this._postRepository.LikeAsync(idUser, idPost);

    public async Task<long> LikeCommentByIdAsync(long userId, long commentId) => await this._postRepository.LikeCommentByIdAsync(userId, commentId);

    public async Task<List<CommentDTO>> GetAllCommentsByPostAsync(CurrentUser user, long postId) {
        List<Comment> comments = await this._postRepository.GetAllCommentsByPostAsync(postId);
        List<long> idsUsers = comments.Select(comment => comment.UserId).Distinct().ToList();

        HttpResponseMessage? responseUsers = await this._httpClient.PostAsJsonAsync("api/v1/users/", idsUsers);

        RestResponse<List<UserDTO>> restResponseUsers = JsonSerializer.Deserialize<RestResponse<List<UserDTO>>>(
            await responseUsers.Content.ReadAsStringAsync(),
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
        )!;

        List<CommentDTO> mappedComments = this._mapper.Map<List<Comment>, List<CommentDTO>>(
            comments,
            options => options.AfterMap((comments, commentsDTO) => {
                for (int i = 0; i < comments.Count; i++) {
                    commentsDTO[i].User = new() { UserId = comments[i].UserId };
                    commentsDTO[i].TotalLikes = comments[i].Likers.Count;
                    commentsDTO[i].IsLikedByMe = comments[i].Likers.Any(post => post.UserId == user.UserId);
                }
            })
        );

        mappedComments.ForEach(postMapped => postMapped.User = restResponseUsers.Data!.First(user => postMapped.User.UserId == user.UserId));
        return mappedComments;
    }
}