using MediatR;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Exceptions;
using Sonorus.Post.Infrastructure.Persistence;

namespace Sonorus.Post.Application.Commands.DeleteCommentById;

public class DeleteCommentByIdCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<DeleteCommentByIdCommand, Unit>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(DeleteCommentByIdCommand request, CancellationToken cancellationToken)
    {
        Core.Entities.Post post = await _unitOfWork.Posts.GetByIdWithFullDataTrackingAsync(request.PostId) ?? throw new PostNotFoundException();
        Comment comment = post.Comments.FirstOrDefault(c => c.CommentId == request.CommentId) ?? throw new CommentNotFoundException();

        if (comment.UserId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfCommentException();

        _unitOfWork.Posts.DeleteCommentFromPost(post, comment);

        await _unitOfWork.BeginTransactionAsync();
        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        return Unit.Value;
    }
}