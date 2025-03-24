using MediatR;

namespace Sonorus.Post.Application.Commands.CreatePost;

public class CreatePostCommand : CreatePostInputModel, IRequest<Unit> {
    public long UserId { get; private set; }

    public CreatePostCommand(long userId, CreatePostInputModel inputModel) {
        this.UserId = userId;
        this.Content = inputModel.Content;
        this.Tablature = inputModel.Tablature;
        this.Medias = inputModel.Medias;
        this.InterestsIds = inputModel.InterestsIds;
    }
}