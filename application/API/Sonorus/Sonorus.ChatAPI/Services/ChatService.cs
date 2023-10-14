using Sonorus.ChatAPI.Services.Interfaces;
using Sonorus.ChatAPI.Data;
using Sonorus.ChatAPI.Repository.Interfaces;
using Sonorus.ChatAPI.DTO;
using Sonorus.ChatAPI.Data.Write;

namespace Sonorus.ChatAPI.Services;

public class ChatService : IChatService {
    private readonly IChatRepository _chatRepository;

    public ChatService(IChatRepository chatRepository) => this._chatRepository = chatRepository;

    public async Task<List<ChatDTO>> GetAllChatsByUserIdAsync(long userId) => await this._chatRepository.GetAllChatsByUserIdAsync(userId);
    
    public async Task<List<MessageDTO>> GetAllMessagesByChatIdAsync(Guid chatId, long userId) => await this._chatRepository.GetAllMessagesByChatIdAsync(chatId, userId);
    
    public async Task AddMessageAsync(long userId, long friendId, Message message) {
        await this._chatRepository.AddMessageAsync(message, friendId);
    }
}