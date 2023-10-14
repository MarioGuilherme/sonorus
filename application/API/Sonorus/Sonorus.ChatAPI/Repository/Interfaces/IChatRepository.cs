using Sonorus.ChatAPI.Data;
using Sonorus.ChatAPI.Data.Write;
using Sonorus.ChatAPI.DTO;

namespace Sonorus.ChatAPI.Repository.Interfaces;

public interface IChatRepository {
    Task<List<ChatDTO>> GetAllChatsByUserIdAsync(long userId);
    Task<List<MessageDTO>> GetAllMessagesByChatIdAsync(Guid chatId, long userId);
    Task AddMessageAsync(Message message, long friendId);
}