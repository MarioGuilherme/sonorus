using MediatR;
using Sonorus.Chat.Application.ViewModels;

namespace Sonorus.Chat.Application.Queries.GetAllChatsByUserId;

public class GetAllChatsByUserIdQuery(long userId) : IRequest<IEnumerable<ChatViewModel>> {
    public long UserId { get; private set; } = userId;
}