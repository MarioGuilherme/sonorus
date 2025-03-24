using MediatR;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Exceptions;
using Sonorus.Post.Infrastructure.Persistence;

namespace Sonorus.Post.Application.Commands.DeleteCommentById;

public class DeleteCommentByIdCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<DeleteCommentByIdCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(DeleteCommentByIdCommand request, CancellationToken cancellationToken) {
        Core.Entities.Post post = await this._unitOfWork.Posts.GetByIdWithFullDataTrackingAsync(request.PostId) ?? throw new PostNotFoundException();
        Comment comment = post.Comments.FirstOrDefault(c => c.CommentId == request.CommentId) ?? throw new CommentNotFoundException();

        if (comment.UserId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfCommentException();

        this._unitOfWork.Posts.DeleteCommentFromPost(post, comment);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return Unit.Value;
    }
}