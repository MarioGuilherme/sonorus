using MediatR;

namespace Sonorus.Post.Application.Commands.ToggleLikeComment;

public class ToggleLikeCommentCommand(long userId, long postId, long commentId) : IRequest<long> {
    public long UserId { get; private set; } = userId;
    public long PostId { get; private set; } = postId;
    public long CommentId { get; private set; } = commentId;
}