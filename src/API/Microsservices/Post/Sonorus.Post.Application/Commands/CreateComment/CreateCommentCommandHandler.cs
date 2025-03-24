using AutoMapper;
using MediatR;
using Sonorus.Post.Application.ViewModels;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Exceptions;
using Sonorus.Post.Infrastructure.Persistence;

namespace Sonorus.Post.Application.Commands.CreateComment;

public class CreateCommentCommandHandler(IUnitOfWork unitOfWork, IMapper mapper) : IRequestHandler<CreateCommentCommand, CommentViewModel> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IMapper _mapper = mapper;

    public async Task<CommentViewModel> Handle(CreateCommentCommand request, CancellationToken cancellationToken) {
        Core.Entities.Post post = await this._unitOfWork.Posts.GetByIdWithFullDataTrackingAsync(request.PostId) ?? throw new PostNotFoundException();
        
        if (post.UserId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfPostException();

        Comment comment = new(request.UserId, request.Content);
        post.Comments.Add(comment);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return new(
            comment.CommentId,
            comment.CommentLikers.Count,
            comment.CommentedAt,
            comment.Content
        );
    }
}