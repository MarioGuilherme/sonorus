using MediatR;
using Sonorus.Post.Application.ViewModels;

namespace Sonorus.Post.Application.Queries.GetAllCommentsByPostId;

public class GetAllCommentsByPostIdQuery(long userId, long postId) : IRequest<IEnumerable<CommentViewModel>> {
    public long UserId { get; private set; } = userId;
    public long PostId { get; private set; } = postId;
}