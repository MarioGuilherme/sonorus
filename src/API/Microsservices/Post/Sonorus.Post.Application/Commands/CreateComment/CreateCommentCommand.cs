using MediatR;
using Sonorus.Post.Application.ViewModels;

namespace Sonorus.Post.Application.Commands.CreateComment;

public class CreateCommentCommand : CreateCommentInputModel, IRequest<CommentViewModel>
{
    public long UserId { get; private set; }
    public long PostId { get; private set; }

    public CreateCommentCommand(long userId, long postId, CreateCommentInputModel inputModel)
    {
        UserId = userId;
        PostId = postId;
        Content = inputModel.Content;
    }
}