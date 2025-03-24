namespace Sonorus.Post.Core.Events;

public class DeletedUserIdEvent(long userId) {
    public long UserId { get; private set; } = userId;
}