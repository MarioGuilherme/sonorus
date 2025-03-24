using MediatR;

namespace Sonorus.Post.Application.Commands.DeleteCommentById;

public class DeleteCommentByIdCommand(long userId, long postId, long commentId) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
    public long PostId { get; private set; } = postId;
    public long CommentId { get; private set; } = commentId;
}