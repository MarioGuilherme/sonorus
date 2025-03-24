namespace Sonorus.Account.Core.Events;

public class DeletedUserEvent(long userId) {
    public long UserId { get; private set; } = userId;
}