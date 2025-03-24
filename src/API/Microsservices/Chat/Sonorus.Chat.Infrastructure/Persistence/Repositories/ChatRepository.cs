using Microsoft.Azure.Cosmos;
using Sonorus.Chat.Core.Entities;
using Sonorus.Chat.Core.Repositories;
using Sonorus.Chat.Infrastructure.Persistence.AntiCorruption;

namespace Sonorus.Chat.Infrastructure.Persistence.Repositories;

public class ChatRepository(Database database) : IChatRepository {
    private readonly Container _container = database.CreateContainerIfNotExistsAsync("Chats", "/chatId").GetAwaiter().GetResult()!;

    public async Task<Core.Entities.Chat> AddMessageToChatAsync(Guid chatId, Message message) {
        QueryDefinition queryDefinition = new(@$"SELECT c.messages FROM c WHERE c.chatId = '{chatId}'");

        FeedIterator<CosmosChat> chatsIterator = this._container.GetItemQueryIterator<CosmosChat>(queryDefinition);
        FeedResponse<CosmosChat> response = await chatsIterator.ReadNextAsync();
        CosmosChat chat = response.First();

        chat.Messages.Add(new() {
            Content = message.Content,
            SentAt = message.SentAt,
            SentByUserId = message.SentByUserId
        });

        await this._container.UpsertItemAsync(chat);

        return new Core.Entities.Chat(
            new(chat.Id),
            chatId,
            chat.Messages.Select(message => new Message(message.Content, message.SentByUserId, message.SentAt)).ToList(),
            chat.Participants
        );
    }

    public async Task CreateAsync(Core.Entities.Chat chat) {
        await this._container.CreateItemAsync<CosmosChat>(new() {
            Id = chat.Id.ToString(),
            ChatId = chat.ChatId.ToString(),
            Messages = chat.Messages.Select(message => new CosmosMessage {
                Content = message.Content,
                SentByUserId = message.SentByUserId,
                SentAt = message.SentAt
            }).ToList(),
            Participants = chat.Participants.ToList()
        });
    }

    public Task DeleteAsync(Core.Entities.Chat chat) => this._container.DeleteItemAsync<CosmosChat>(chat.Id.ToString(), new(chat.ChatId.ToString()));

    public async Task<IEnumerable<Core.Entities.Chat>> GetAllChatByUserIdAsync(long userId) {
        QueryDefinition queryDefinition = new($"SELECT c.id, c.chatId, c.participants, ARRAY_SLICE(c.messages, -1) AS messages FROM c WHERE ARRAY_CONTAINS(c.participants, {userId})");
        FeedIterator<CosmosChat> chatsIterator = this._container.GetItemQueryIterator<CosmosChat>(queryDefinition);
        ICollection<Core.Entities.Chat> chats = [];

        while (chatsIterator.HasMoreResults) {
            FeedResponse<CosmosChat> response = await chatsIterator.ReadNextAsync();

            foreach (CosmosChat cosmosChat in response)
                chats.Add(new(
                    new(cosmosChat.Id),
                    new(cosmosChat.ChatId),
                    cosmosChat.Messages.Select(message => new Message(message.Content, message.SentByUserId, message.SentAt)).ToList(),
                    cosmosChat.Participants
                ));
        }

        return chats;
    }

    public async Task<IEnumerable<Message>?> GetAllMessagesByChatIdAsync(Guid chatId) {
        QueryDefinition queryDefinition = new($"SELECT c.messages FROM c WHERE c.chatId = '{chatId}'");
        FeedIterator<CosmosChat> chatIterator = this._container.GetItemQueryIterator<CosmosChat>(queryDefinition);
        FeedResponse<CosmosChat> response = await chatIterator.ReadNextAsync();
        CosmosChat? chat = response.FirstOrDefault();

        if (chat is null) return null;

        ICollection<Message> messages = [];

        foreach (CosmosMessage cosmosMessage in chat.Messages)
            messages.Add(new(
                cosmosMessage.Content,
                cosmosMessage.SentByUserId,
                cosmosMessage.SentAt
            ));

        return messages;
    }

    public async Task<Core.Entities.Chat?> GetByFriendIdAsync(long userId, long friendId) {
        QueryDefinition queryDefinition = new($"SELECT c.id, c.chatId, c.messages, c.participants FROM c WHERE ARRAY_CONTAINS(c.participants, {userId}) AND ARRAY_CONTAINS(c.participants, {friendId})");
        FeedIterator<CosmosChat> chatsIterator = this._container.GetItemQueryIterator<CosmosChat>(queryDefinition);
        FeedResponse<CosmosChat> response = await chatsIterator.ReadNextAsync();
        CosmosChat? cosmosChat = response.FirstOrDefault();

        if (cosmosChat is null) return null;

        return new Core.Entities.Chat(
            new(cosmosChat.Id),
            new(cosmosChat.ChatId),
            cosmosChat.Messages.Select(message => new Message(message.Content, message.SentByUserId, message.SentAt)).ToList(),
            cosmosChat.Participants
        );
    }

    public async Task<Core.Entities.Chat?> GetByIdAsync(Guid chatId) {
        QueryDefinition queryDefinition = new($"SELECT c.id, c.messages, c.participants FROM c WHERE c.chatId = '{chatId}'");
        FeedIterator<CosmosChat> chatsIterator = this._container.GetItemQueryIterator<CosmosChat>(queryDefinition);
        FeedResponse<CosmosChat> response = await chatsIterator.ReadNextAsync();
        CosmosChat? cosmosChat = response.FirstOrDefault();

        if (cosmosChat is null)
            return null;

        return new Core.Entities.Chat(
            new(cosmosChat.Id),
            chatId,
            cosmosChat.Messages.Select(message => new Message(message.Content, message.SentByUserId, message.SentAt)).ToList(),
            cosmosChat.Participants
        );
    }

    public async Task<ICollection<string>> GetConnectionIdByParticipantsIdAsync(IEnumerable<long> participants) {
        QueryDefinition queryDefinition = new(@$"
            SELECT c.connectionId
            FROM c WHERE ARRAY_CONTAINS(c.userId, [{string.Join(',', participants)}])
        ");
        FeedIterator<CosmosConnection> connectionsIterator = this._container.GetItemQueryIterator<CosmosConnection>(queryDefinition);
        ICollection<string> connectionsIds = [];

        while (connectionsIterator.HasMoreResults) {
            FeedResponse<CosmosConnection> response = await connectionsIterator.ReadNextAsync();

            foreach (CosmosConnection cosmosConnection in response)
                connectionsIds.Add(cosmosConnection.ConnectionId);
        }

        return connectionsIds;
    }

    public Task UpdateAsync(Core.Entities.Chat chat) => this._container.ReplaceItemAsync(new CosmosChat {
        ChatId = chat.ChatId.ToString(),
        Id = chat.Id.ToString(),
        Messages = chat.Messages.Select(message => new CosmosMessage {
            Content = message.Content,
            SentByUserId = message.SentByUserId,
            SentAt = message.SentAt
        }).ToList(),
        Participants = chat.Participants.ToList()
    }, chat.Id.ToString(), new(chat.ChatId.ToString()));
}