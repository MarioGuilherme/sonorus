using MediatR;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Exceptions;
using Sonorus.Post.Infrastructure.Persistence;

namespace Sonorus.Post.Application.Commands.ToggleLikePost;

public class ToggleLikePostCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<ToggleLikePostCommand, long> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<long> Handle(ToggleLikePostCommand request, CancellationToken cancellationToken) {
        Core.Entities.Post post = await this._unitOfWork.Posts.GetByIdWithPostLikersTrackingAsync(request.PostId) ?? throw new PostNotFoundException();
        PostLiker? postLiker = post.PostLikers.FirstOrDefault(post => post.UserId == request.UserId);

        if (postLiker is null)
            post.PostLikers.Add(new(request.UserId));
        else
            post.PostLikers.Remove(postLiker);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return post.PostLikers.Count;
    }
}