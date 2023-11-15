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

    public async Task SendMessage(string? chatId, long friendId, long sentByUserId, string content, string messageId) {
        chatId ??= await this._chatService.CreateNewChatAsync(sentByUserId, friendId);

        Message message = new() {
            MessageId = messageId,
            Content = content,
            SentAt = DateTime.Now,
            SentByUserId = sentByUserId
        };
        await this._chatService.AddMessageAsync(Guid.Parse(chatId!), message);
        MessageDTO messageDTO = new() {
            Content = message.Content,
            SentAt = message.SentAt
        };

        await Clients.Others.SendAsync("ReceiveMessage", messageDTO);
        await Clients.Caller.SendAsync("MessageSent", messageId);
    }
}