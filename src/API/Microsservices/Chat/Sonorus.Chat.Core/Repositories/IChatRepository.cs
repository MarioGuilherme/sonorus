using Sonorus.Chat.Core.Entities;

namespace Sonorus.Chat.Core.Repositories;

public interface IChatRepository {
    Task<Entities.Chat> AddMessageToChatAsync(Guid chatId, Message message);
    Task CreateAsync(Entities.Chat chat);
    Task DeleteAsync(Entities.Chat chat);
    Task<IEnumerable<Entities.Chat>> GetAllChatByUserIdAsync(long userId);
    Task<IEnumerable<Message>?> GetAllMessagesByChatIdAsync(Guid chatId);
    Task<Entities.Chat?> GetByFriendIdAsync(long userId, long friendId);
    Task<Entities.Chat?> GetByIdAsync(Guid chatId);
    Task<ICollection<string>> GetConnectionIdByParticipantsIdAsync(IEnumerable<long> participants);
    Task UpdateAsync(Entities.Chat chat);
}