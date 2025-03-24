using MediatR;

namespace Sonorus.Post.Application.Commands.DeletePostById;

public class DeletePostByIdCommand(long userId, long postId) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
    public long PostId { get; private set; } = postId;
}