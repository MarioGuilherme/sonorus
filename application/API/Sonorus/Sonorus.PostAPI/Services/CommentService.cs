using AutoMapper;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Repository.Interfaces;
using Sonorus.PostAPI.Services.Interfaces;
using System.Text.Json;
using Microsoft.Extensions.Hosting;

namespace Sonorus.PostAPI.Services;

public class CommentService : ICommentService {
    private readonly HttpClient _httpClient;
    private readonly ICommentRepository _commentRepository;
    private readonly IMapper _mapper;

    public CommentService(HttpClient httpClient, ICommentRepository commentRepository, IMapper mapper) {
        this._httpClient = httpClient;
        this._commentRepository = commentRepository;
        this._mapper = mapper;
    }

    public async Task DeleteCommentById(long userId, long commentId) => await this._commentRepository.DeleteCommentById(userId, commentId);

    public async Task<List<CommentDTO>> GetAllByPostIdAsync(long postId, CurrentUser user) {
        List<Comment> comments = await this._commentRepository.GetAllByPostIdAsync(postId);
        List<long> userIds = comments.Select(comment => comment.UserId).Distinct().ToList();

        this._httpClient.DefaultRequestHeaders.Add("userIds", string.Join(",", userIds));
        RestResponse<List<UserDTO>> restResponseUsers = (await this._httpClient.GetFromJsonAsync<RestResponse<List<UserDTO>>>("api/v1/users/"))!;

        List<CommentDTO> mappedComments = this._mapper.Map<List<Comment>, List<CommentDTO>>(
            comments,
            options => options.AfterMap((comments, commentsDTO) => {
                for (int i = 0; i < comments.Count; i++) {
                    commentsDTO[i].Author = new() { UserId = comments[i].UserId };
                    commentsDTO[i].TotalLikes = comments[i].Likers.Count;
                    commentsDTO[i].IsLikedByMe = comments[i].Likers.Any(post => post.UserId == user.UserId);
                }
            })
        );

        mappedComments.ForEach(postMapped => postMapped.Author = restResponseUsers!.Data!.First(user => postMapped.Author.UserId == user.UserId));
        return mappedComments;
    }
    
    public async Task<long> LikeByCommentIdAsync(long commentId, long userId) => await this._commentRepository.LikeByCommentIdAsync(commentId, userId);

    public async Task<CommentDTO> SaveCommentAsync(long userId, NewCommentDTO newComment) {
        Comment comment = await this._commentRepository.SaveCommentAsync(newComment.PostId, new() {
            Content = newComment.Content,
            UserId = userId
        });
        return this._mapper.Map<CommentDTO>(comment);
    }

    public async Task UpdateCommentById(long userId, long postId, string newContent) => await this._commentRepository.UpdateCommentByIdAsync(userId, postId, newContent);
}