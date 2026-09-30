using MediatR;

namespace Sonorus.Post.Application.Commands.UpdatePost;

public class UpdatePostCommand : UpdatePostInputModel, IRequest<Unit> {
    public long UserId { get; private set; }
    public long PostId { get; private set; }

    public UpdatePostCommand(long userId, long postId, UpdatePostInputModel inputModel) {
        UserId = userId;
        PostId = postId;
        Content = inputModel.Content;
        Tablature = inputModel.Tablature;
        InterestsIds = inputModel.InterestsIds;
        NewMedias = inputModel.NewMedias;
        MediasToRemove = inputModel.MediasToRemove;
    }
}