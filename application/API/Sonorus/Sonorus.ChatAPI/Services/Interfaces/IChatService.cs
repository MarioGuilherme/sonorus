using Sonorus.ChatAPI.Data;
using Sonorus.ChatAPI.DTO;

namespace Sonorus.ChatAPI.Services.Interfaces;

public interface IChatService {
    Task<List<ChatDTO>> GetAllChatsByUserIdAsync(long userId);
    Task<List<MessageDTO>> GetAllMessagesByChatIdAsync(Guid chatId, long userId);
    Task<List<MessageDTO>> GetAllMessagesWithFriendAsync(long userId, long myId);
    Task AddMessageAsync(Guid chatId, Message message);
}