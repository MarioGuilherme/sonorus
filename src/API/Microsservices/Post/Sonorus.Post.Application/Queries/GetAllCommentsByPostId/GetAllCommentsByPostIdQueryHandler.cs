using AutoMapper;
using MediatR;
using Sonorus.Post.Application.ViewModels;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Exceptions;
using Sonorus.Post.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Post.Application.Queries.GetAllCommentsByPostId;

public class GetAllCommentsByPostIdQueryHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory, IMapper mapper) : IRequestHandler<GetAllCommentsByPostIdQuery, IEnumerable<CommentViewModel>> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;
    private readonly IMapper _mapper = mapper;

    public async Task<IEnumerable<CommentViewModel>> Handle(GetAllCommentsByPostIdQuery request, CancellationToken cancellationToken) {
        IEnumerable<Comment> comments = await this._unitOfWork.Posts.GetAllCommentsByPostIdAsync(request.PostId) ?? throw new PostNotFoundException();
        if (!comments.Any()) return [];

        IEnumerable<long> userIds = comments.Select(comment => comment.UserId).Distinct();
        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>(
            $"users?{string.Join('&', userIds.Select(userId => $"id={userId}"))}",
            cancellationToken: cancellationToken
        );

        ICollection<CommentViewModel> mappedComments = [];
        foreach (Comment comment in comments) {
            UserViewModel? author = users!.FirstOrDefault(user => user.UserId == comment.UserId);
            if (author is null) continue;
            CommentViewModel commentViewModel = new(
                comment.CommentId,
                comment.CommentLikers.Count,
                comment.CommentedAt,
                comment.Content
            ) {
                Author = author,
                IsLikedByMe = comment.CommentLikers.Any(post => post.UserId == request.UserId)
            };
            mappedComments.Add(commentViewModel);
        }

        return mappedComments;
    }
}