using MediatR;

namespace Sonorus.Post.Application.Commands.CreatePost;

public class CreatePostCommand : CreatePostInputModel, IRequest<Unit> {
    public long UserId { get; private set; }

    public CreatePostCommand(long userId, CreatePostInputModel inputModel) {
        UserId = userId;
        Content = inputModel.Content;
        Tablature = inputModel.Tablature;
        Medias = inputModel.Medias;
        InterestsIds = inputModel.InterestsIds;
    }
}