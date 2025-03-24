using MediatR;

namespace Sonorus.Post.Application.Commands.UpdatePost;

public class UpdatePostCommand : UpdatePostInputModel, IRequest<Unit> {
    public long UserId { get; private set; }
    public long PostId { get; private set; }

    public UpdatePostCommand(long userId, long postId, UpdatePostInputModel inputModel) {
        this.UserId = userId;
        this.PostId = postId;
        this.Content = inputModel.Content;
        this.Tablature = inputModel.Tablature;
        this.InterestsIds = inputModel.InterestsIds;
        this.NewMedias = inputModel.NewMedias;
        this.MediasToRemove = inputModel.MediasToRemove;
    }
}