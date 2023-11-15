using Sonorus.ChatAPI.Services.Interfaces;
using Sonorus.ChatAPI.Data;
using Sonorus.ChatAPI.Repository.Interfaces;
using Sonorus.ChatAPI.DTO;
using Sonorus.ChatAPI.Hubs;
using Microsoft.AspNetCore.SignalR;
using System.Text.Json;
using Sonorus.ChatAPI.Models;

namespace Sonorus.ChatAPI.Services;

public class ChatService : IChatService {
    private readonly HttpClient _httpClient;
    private readonly IChatRepository _chatRepository;
    private readonly IHubContext<ChatHub> _chatHubContext;

    public ChatService(HttpClient httpClient, IChatRepository chatRepository, IHubContext<ChatHub> chatHubContext) {
        this._httpClient = httpClient;
        this._chatRepository = chatRepository;
        this._chatHubContext = chatHubContext;
    }

    public async Task<List<ChatDTO>> GetAllChatsByUserIdAsync(long userId) {
        List<ChatDTO> chatDTOs = await this._chatRepository.GetAllChatsByUserIdAsync(userId);

        foreach (ChatDTO chat in chatDTOs)
            chat.Friend = await this.GetUserFriendAsync(chat.Friend.UserId);

        return chatDTOs;
    }
    
    public async Task<List<MessageDTO>> GetAllMessagesByChatIdAsync(Guid chatId, long userId) => await this._chatRepository.GetAllMessagesByChatIdAsync(chatId, userId);

    public async Task<ChatDTO> GetChatWithFriendAsync(long friendId, long myId) => await this._chatRepository.GetChatWithFriendAsync(friendId, myId);
    
    public async Task AddMessageAsync(Guid chatId, Message message) => await this._chatRepository.AddMessageAsync(chatId, message);

    private async Task<User> GetUserFriendAsync(long userId) {
        this._httpClient.DefaultRequestHeaders.Add("userIds", userId.ToString());
        RestResponse<List<User>> response = (await this._httpClient.GetFromJsonAsync<RestResponse<List<User>>>("api/v1/users/"))!;
        User user = response.Data!.FirstOrDefault(new User {
            Nickname = "usuario.excluido",
            UserId = 0,
            Picture = "https://cdn-icons-png.flaticon.com/512/1077/1077114.png"
        });
        return user;
    }

    public async Task<string> CreateNewChatAsync(long friendUserId, long myUserId) => await this._chatRepository.CreateNewChatAsync(friendUserId, myUserId);
}