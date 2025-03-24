using AutoMapper;
using MediatR;
using Sonorus.Chat.Application.ViewModels;
using Sonorus.Chat.Core.Entities;
using Sonorus.Chat.Core.Repositories;
using System.Net.Http.Json;

namespace Sonorus.Chat.Application.Queries.GetAllChatsByUserId;

public class GetAllChatsByUserIdQueryHandler(
    IChatRepository chatRepository,
    IHttpClientFactory httpClientFactory,
    IMapper mapper
) : IRequestHandler<GetAllChatsByUserIdQuery, IEnumerable<ChatViewModel>> {
    private readonly IChatRepository _chatRepository = chatRepository;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;
    private readonly IMapper _mapper = mapper;

    public async Task<IEnumerable<ChatViewModel>> Handle(GetAllChatsByUserIdQuery request, CancellationToken cancellationToken) {
        IEnumerable<Core.Entities.Chat> chats = await this._chatRepository.GetAllChatByUserIdAsync(request.UserId);
        if (!chats.Any()) return [];

        IEnumerable<long> usersIds = chats.SelectMany(chat => chat.Participants).Distinct();

        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>(
            $"users?{string.Join('&', usersIds.Select(userId => $"id={userId}"))}",
            cancellationToken: cancellationToken
        );

        ICollection<ChatViewModel> mappedChats = [];
        foreach (Core.Entities.Chat chat in chats) {
            ChatViewModel chatViewModel = new(
                chat.Id,
                chat.Messages.Select(m => new MessageViewModel(m.Content, m.SentByUserId, m.SentAt))
            ) {
                Participants = chat.Participants.Select(userId => users!.FirstOrDefault(user => user.UserId == userId)).Where(u => u != null)!
            };
            mappedChats.Add(chatViewModel);
        }

        return mappedChats;
    }
}