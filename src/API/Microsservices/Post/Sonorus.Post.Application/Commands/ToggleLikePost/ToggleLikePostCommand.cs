using MediatR;

namespace Sonorus.Post.Application.Commands.ToggleLikePost;

public class ToggleLikePostCommand(long userId, long postId) : IRequest<long> {
    public long UserId { get; private set; } = userId;
    public long PostId { get; private set; } = postId;
}