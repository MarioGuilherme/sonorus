using MediatR;
using Sonorus.Chat.Application.ViewModels;
using Sonorus.Chat.Core.Entities;
using Sonorus.Chat.Core.Exceptions;
using Sonorus.Chat.Core.Repositories;
using System.Net.Http.Json;

namespace Sonorus.Chat.Application.Queries.GetChatByFriendUserId;

public class GetChatByFriendUserIdQueryHandler(IChatRepository chatRepository, IHttpClientFactory httpClientFactory) : IRequestHandler<GetChatByFriendUserIdQuery, ChatViewModel> {
    private readonly IChatRepository _chatRepository = chatRepository;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;

    public async Task<ChatViewModel> Handle(GetChatByFriendUserIdQuery request, CancellationToken cancellationToken) {
        Core.Entities.Chat chatDb = await this._chatRepository.GetByFriendIdAsync(request.UserId, request.FriendId) ?? throw new ChatNotFoundException();

        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>($"users?{string.Join('&', chatDb.Participants.Select(userId => $"id={userId}"))}", cancellationToken: cancellationToken);

        ICollection<MessageViewModel> mappedMessages = [];
        foreach (Message messageDb in chatDb.Messages)
            mappedMessages.Add(new(messageDb.Content, messageDb.SentByUserId, messageDb.SentAt));

        ChatViewModel chatViewModel = new(chatDb.ChatId, mappedMessages) {
            Participants = chatDb.Participants.Select(userId => users!.FirstOrDefault(user => user.UserId == userId)).Where(u => u != null)!
        };

        return chatViewModel;
    }
}