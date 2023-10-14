using Sonorus.ChatAPI.Data;
using Sonorus.ChatAPI.Data.Write;
using Sonorus.ChatAPI.DTO;

namespace Sonorus.ChatAPI.Services.Interfaces;

public interface IChatService {
    Task<List<ChatDTO>> GetAllChatsByUserIdAsync(long userId);
    Task<List<MessageDTO>> GetAllMessagesByChatIdAsync(Guid chatId, long userId);
    Task AddMessageAsync(long userId, long friendId, Message message);
}