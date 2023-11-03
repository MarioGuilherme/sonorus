using Microsoft.AspNetCore.SignalR;
using Sonorus.ChatAPI.Data;
using Sonorus.ChatAPI.DTO;
using Sonorus.ChatAPI.Services.Interfaces;

namespace Sonorus.ChatAPI.Hubs;

public class ChatHub : Hub {
    private readonly IChatService _chatService;

    public ChatHub(IChatService chatService) => this._chatService = chatService;

    public override Task OnConnectedAsync() {
        return base.OnConnectedAsync();
    }

    public async Task SendMessage(string chatId, long sentByUserId, string content) {
        Message message = new() {
            Content = content,
            SentAt = DateTime.Now,
            SentByUserId = sentByUserId
        };
        await this._chatService.AddMessageAsync(Guid.Parse(chatId), message);
        MessageDTO messageDTO = new() {
            Content = message.Content,
            SentAt = message.SentAt
        };
        await Clients.Others.SendAsync("ReceiveMessage", messageDTO);
        messageDTO.IsSentByMe = true;
        await Clients.Caller.SendAsync("MessageSent", messageDTO);
    }
}