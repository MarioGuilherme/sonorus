using MediatR;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Exceptions;
using Sonorus.Post.Infrastructure.Persistence;

namespace Sonorus.Post.Application.Commands.ToggleLikeComment;

public class ToggleLikeCommentCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<ToggleLikeCommentCommand, long> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<long> Handle(ToggleLikeCommentCommand request, CancellationToken cancellationToken) {
        Core.Entities.Post post = await this._unitOfWork.Posts.GetByIdWithFullDataTrackingAsync(request.PostId) ?? throw new PostNotFoundException();
        Comment comment = post.Comments.FirstOrDefault(comment => comment.CommentId == request.CommentId) ?? throw new CommentNotFoundException();
        CommentLiker? commentLiker = comment.CommentLikers.FirstOrDefault(comment => comment.UserId == request.UserId);

        if (commentLiker is null)
            comment.CommentLikers.Add(new(request.UserId));
        else
            comment.CommentLikers.Remove(commentLiker);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return await this._unitOfWork.Posts.GetTotalLikersOfCommentIdAsync(request.CommentId);
    }
}