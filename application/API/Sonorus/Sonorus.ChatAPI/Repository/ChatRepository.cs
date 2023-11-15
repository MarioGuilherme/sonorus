using Microsoft.Azure.Cosmos;
using Sonorus.ChatAPI.Configuration;
using Sonorus.ChatAPI.DTO;
using Sonorus.ChatAPI.Repository.Interfaces;
using Sonorus.ChatAPI.Data;
using System;

namespace Sonorus.ChatAPI.Repository;

public class ChatRepository : IChatRepository {
    private readonly string _endpointUri = Environment.GetEnvironmentVariable("COSMOS_DB_ENDPOINT_URI")!;
    private readonly string _primaryKey = Environment.GetEnvironmentVariable("COSMOS_DB_PRIMARY_KEY")!;
    private readonly string _databaseName = Environment.GetEnvironmentVariable("COSMOS_DB_NAME")!;
    private readonly CosmosClient _cosmosClient;
    private readonly Container _chatContainer;
    private readonly Database _database;

    public ChatRepository() {
        this._cosmosClient = new(
            this._endpointUri,
            this._primaryKey,
            new() {
                ApplicationName = "Sonorus.ChatAPI",
                Serializer = new CosmosDbSerializer(),
                //AllowBulkExecution = true,
                //ConnectionMode = ConnectionMode.Gateway // => Rede da Fatec
            }
        );
        this._database = this._cosmosClient.CreateDatabaseIfNotExistsAsync(this._databaseName).GetAwaiter().GetResult()!;
        this._chatContainer = this._database.CreateContainerIfNotExistsAsync("Chats", "/chatId").GetAwaiter().GetResult()!;
    }

    public async Task<List<ChatDTO>> GetAllChatsByUserIdAsync(long userId) {
        QueryDefinition queryDefinition = new($"SELECT c.chatId, c.relatedUsersId, ARRAY_SLICE(c.messages, -1) AS messages FROM c WHERE ARRAY_CONTAINS(c.relatedUsersId, {userId})");
        FeedIterator<Chat> chatsIterator = this._chatContainer.GetItemQueryIterator<Chat>(queryDefinition);

        List<ChatDTO> chatDTOs = new();

        while (chatsIterator.HasMoreResults) {
            FeedResponse<Chat> response = await chatsIterator.ReadNextAsync();
            List<Chat> chats = response.ToList();

            foreach (Chat chat in chats) {
                long friendId = chat.RelatedUsersId[0] == userId ? chat.RelatedUsersId[1] : chat.RelatedUsersId[0];
                Message lastMessage = chat.Messages.First();

                chatDTOs.Add(new() {
                    ChatId = chat.ChatId,
                    Friend = new() { UserId = friendId },
                    Messages = new() {
                        new() {
                            Content = lastMessage.Content,
                            SentAt = lastMessage.SentAt,
                            IsSentByMe = lastMessage.SentByUserId == userId
                        }
                    }
                });
            }
        }

        return chatDTOs;
    }

    public async Task<ChatDTO> GetChatWithFriendAsync(long friendId, long myId) {
        QueryDefinition queryDefinition = new($"""
            SELECT
                c.chatId,
                c.messages
            FROM c
            WHERE ARRAY_CONTAINS(c.relatedUsersId, {friendId}) AND ARRAY_CONTAINS(c.relatedUsersId, {myId})
        """);

        FeedIterator<Chat> chatsIterator = this._chatContainer.GetItemQueryIterator<Chat>(queryDefinition);
        FeedResponse<Chat> response = await chatsIterator.ReadNextAsync();
        Chat? chat = response.FirstOrDefault();

        if (chat is null)
            return new();

        ChatDTO chatDTO = new() {
            Friend = new() { UserId = friendId, Nickname = string.Empty, Picture = string.Empty },
            Messages = new(),
            ChatId = chat.ChatId
        };

        chat.Messages.ForEach(message => chatDTO.Messages.Add(new() {
            Content = message.Content,
            IsSentByMe = message.SentByUserId == myId,
            SentAt = message.SentAt
        }));

        return chatDTO;
    }

    public async Task<List<MessageDTO>> GetAllMessagesByChatIdAsync(Guid chatId, long userId) {
        QueryDefinition queryDefinition = new($"""
            SELECT
               c.messages
            FROM c
            WHERE c.chatId = '{chatId}'
        """);

        FeedIterator<Chat> chatsIterator = this._chatContainer.GetItemQueryIterator<Chat>(queryDefinition);
        FeedResponse<Chat> response = await chatsIterator.ReadNextAsync();
        Chat chat = response.First();
        List<MessageDTO> messageDTOs = new();

        chat.Messages.ForEach(message => messageDTOs.Add(new() {
            Content = message.Content,
            IsSentByMe = message.SentByUserId == userId,
            SentAt = message.SentAt
        }));

        return messageDTOs;
    }

    public async Task<string> CreateNewChatAsync(long friendUserId, long myUserId) {
        string guid = Guid.NewGuid().ToString();
        await this._chatContainer.CreateItemAsync(new Chat {
            ChatId = guid,
            Id = Guid.NewGuid().ToString(),
            Messages = new(),
            RelatedUsersId = new long[2] { friendUserId, myUserId }
        });
        return guid;
    }

    public async Task AddMessageAsync(Guid chatId, Message message) {
        QueryDefinition queryDefinition = new($"""
                SELECT
                   c.id, c.chatId, c.relatedUsersId, c.messages
                FROM c
                WHERE c.chatId = '{chatId}'
            """);

        FeedIterator<Chat> chatsIterator = this._chatContainer.GetItemQueryIterator<Chat>(queryDefinition);
        FeedResponse<Chat> response = await chatsIterator.ReadNextAsync();
        Chat chat = response.First();

        chat.Messages.Add(message);

        await this._chatContainer.UpsertItemAsync(chat);
    }
}