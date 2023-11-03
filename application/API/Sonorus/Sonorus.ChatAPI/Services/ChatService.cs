using Sonorus.ChatAPI.Services.Interfaces;
using Sonorus.ChatAPI.Data;
using Sonorus.ChatAPI.Repository.Interfaces;
using Sonorus.ChatAPI.DTO;
using Sonorus.ChatAPI.Hubs;
using Microsoft.AspNetCore.SignalR;
using System.Text.Json;
using Sonorus.ChatAPI.Models;
using System;

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

    public async Task<List<MessageDTO>> GetAllMessagesWithFriendAsync(long userId, long myId) => await this._chatRepository.GetAllMessagesWithFriendAsync(userId, myId);
    
    public async Task AddMessageAsync(Guid chatId, Message message) => await this._chatRepository.AddMessageAsync(chatId, message);

    private async Task<User> GetUserFriendAsync(long userId) {
        this._httpClient.DefaultRequestHeaders.Add("UserIds", JsonSerializer.Serialize(new List<long> { userId }));
        HttpResponseMessage? response = await this._httpClient.GetAsync("api/v1/users/");

        if (!response.IsSuccessStatusCode)
            throw new ArgumentException($"Something went wrong when calling the API : {response.ReasonPhrase}");

        RestResponse<List<User>> restResponseUsers = JsonSerializer.Deserialize<RestResponse<List<User>>>(
            await response.Content.ReadAsStringAsync(),
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
        )!;

        return restResponseUsers.Data!.First();
    }
}