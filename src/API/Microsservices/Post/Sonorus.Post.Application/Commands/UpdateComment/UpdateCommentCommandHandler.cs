using MediatR;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Exceptions;
using Sonorus.Post.Infrastructure.Persistence;

namespace Sonorus.Post.Application.Commands.UpdateComment;

public class UpdateCommentCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<UpdateCommentCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(UpdateCommentCommand request, CancellationToken cancellationToken) {
        Core.Entities.Post post = await this._unitOfWork.Posts.GetByIdWithFullDataTrackingAsync(request.PostId) ?? throw new PostNotFoundException();
        Comment comment = post.Comments.FirstOrDefault(c => c.CommentId == request.CommentId) ?? throw new CommentNotFoundException();

        if (comment.UserId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfCommentException();

        comment.UpdateContent(request.Content);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return Unit.Value;
    }
}