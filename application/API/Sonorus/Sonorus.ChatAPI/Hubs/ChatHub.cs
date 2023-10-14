using Microsoft.AspNetCore.SignalR;
using Sonorus.ChatAPI.Data.Write;
using Sonorus.ChatAPI.DTO;
using Sonorus.ChatAPI.Services.Interfaces;

namespace Sonorus.ChatAPI.Hubs;

public class ChatHub : Hub {
    private readonly IChatService _chatService;

    public ChatHub(IChatService chatService) => this._chatService = chatService;

    public async Task SendMessage(long userId, long friendId, string contentMessage) {
        try {
            Message message = new() {
                Content = contentMessage,
                SentAt = DateTime.Now,
                SentByUserId = userId
            };
            MessageDTO messageDTO = new() {
                Content = contentMessage,
                IsSentByMe = true,
                SentAt = message.SentAt,
                MessageId = message.MessageId
            };
            await this._chatService.AddMessageAsync(userId, friendId, message);
            await Clients.All.SendAsync("ReceiveMessage", messageDTO);
        } catch (Exception ex) {

        }
    }
}