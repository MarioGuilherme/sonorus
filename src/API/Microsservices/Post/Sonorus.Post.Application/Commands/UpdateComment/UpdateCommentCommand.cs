using MediatR;

namespace Sonorus.Post.Application.Commands.UpdateComment;

public class UpdateCommentCommand : UpdateCommentInputModel, IRequest<Unit> {
    public long UserId { get; private set; }
    public long PostId { get; private set; }
    public long CommentId { get; private set; }

    public UpdateCommentCommand(long userId, long postId, long commentId, UpdateCommentInputModel inputModel) {
        this.UserId = userId;
        this.PostId = postId;
        this.CommentId = commentId;
        this.Content = inputModel.Content;
    }
}