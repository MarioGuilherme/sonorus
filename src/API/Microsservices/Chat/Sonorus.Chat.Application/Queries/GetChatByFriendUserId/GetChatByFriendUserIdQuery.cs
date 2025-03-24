using MediatR;
using Sonorus.Chat.Application.ViewModels;

namespace Sonorus.Chat.Application.Queries.GetChatByFriendUserId;

public class GetChatByFriendUserIdQuery(long userId, long friendId) : IRequest<ChatViewModel> {
    public long UserId { get; private set; } = userId;
    public long FriendId { get; private set; } = friendId;
}