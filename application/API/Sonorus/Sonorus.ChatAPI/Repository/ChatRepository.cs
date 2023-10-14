using Microsoft.Azure.Cosmos;
using Sonorus.ChatAPI.Configuration;
using Sonorus.ChatAPI.DTO;
using Sonorus.ChatAPI.Repository.Interfaces;
using User = Sonorus.ChatAPI.Data.Read.User;
using Chat = Sonorus.ChatAPI.Data.Read.Chat;
using Message = Sonorus.ChatAPI.Data.Read.Message;
using Sonorus.ChatAPI.Data;

namespace Sonorus.ChatAPI.Repository;

public class ChatRepository : IChatRepository {
    private readonly string _endpointUri = Environment.GetEnvironmentVariable("COSMOS_DB_ENDPOINT_URI")!;
    private readonly string _primaryKey = Environment.GetEnvironmentVariable("COSMOS_DB_PRIMARY_KEY")!;
    private readonly string _databaseName = Environment.GetEnvironmentVariable("COSMOS_DB_NAME")!;
    private readonly CosmosClient _cosmosClient;
    private readonly Container _chatContainer;
    private readonly Container _messageContainer;
    private readonly Container _userContainer;
    private readonly Database _database;

    public ChatRepository() {
        this._cosmosClient = new(
            this._endpointUri,
            this._primaryKey,
            new() {
                ApplicationName = "Sonorus.ChatAPI",
                Serializer = new CosmosDbSerializer()
            }
        );
        this._database = this._cosmosClient.CreateDatabaseIfNotExistsAsync(this._databaseName).GetAwaiter().GetResult()!;
        this._chatContainer = this._database.CreateContainerIfNotExistsAsync("Chats", "/chatId").GetAwaiter().GetResult()!;
        this._messageContainer = this._database.CreateContainerIfNotExistsAsync("Messages", "/messageId").GetAwaiter().GetResult()!;
        this._userContainer = this._database.CreateContainerIfNotExistsAsync("Users", "/userId").GetAwaiter().GetResult()!;
    }

    public async Task<List<ChatDTO>> GetAllChatsByUserIdAsync(long userId) {
        QueryDefinition queryDefinition = new($"SELECT c.chatId, c.relatedUsers, c.messages FROM c WHERE ARRAY_CONTAINS(c.relatedUsers, {userId})");
        FeedIterator<Chat> chatsIterator = this._chatContainer.GetItemQueryIterator<Chat>(queryDefinition);

        List<ChatDTO> chatDTOs = new();

        while (chatsIterator.HasMoreResults) {
            FeedResponse<Chat> response = await chatsIterator.ReadNextAsync();
            List<Chat> chats = response.ToList();

            foreach (Chat chat in chats) {
                // Consultará e buscará apenas a última mensagem da conversa
                QueryDefinition lastMessageQuery = new($"SELECT m.messageId, m.sentByUserId, m.content, m.sentAt FROM m WHERE m.messageId = \"{chat.Messages.Last().MessageId}\"");
                FeedIterator<Message> lastMessageIterator = this._messageContainer.GetItemQueryIterator<Message>(lastMessageQuery);
                FeedResponse<Message> lastMessageResponse = await lastMessageIterator.ReadNextAsync();
                Message lastMessage = lastMessageResponse.Single();

                // Consulta para obter informações do amigo da conversa
                long friendId = chat.RelatedUsers[0] == userId ? chat.RelatedUsers[1] : chat.RelatedUsers[0];
                QueryDefinition friendQuery = new($"SELECT c.userId, c.nickname, c.picture FROM c WHERE c.userId = {friendId}");
                FeedIterator<User> friendIterator = this._userContainer.GetItemQueryIterator<User>(friendQuery);
                FeedResponse<User> friendResponse = await friendIterator.ReadNextAsync();
                User friend = friendResponse.Single();

                chatDTOs.Add(new() {
                    ChatId = chat.ChatId,
                    Messages = new() {
                        new MessageDTO {
                            Content = lastMessage.Content,
                            MessageId = lastMessage.MessageId,
                            IsSentByMe = lastMessage.SentByUserId == userId,
                            SentAt = lastMessage.SentAt,
                        }
                    },
                    Friend = friend
                });
            }
        }

        return chatDTOs;
    }

    public async Task<List<MessageDTO>> GetAllMessagesByChatIdAsync(Guid chatId, long userId) {
        QueryDefinition queryDefinition = new($"SELECT c.chatId, c.relatedUsers, c.messages FROM c WHERE ARRAY_CONTAINS(c.relatedUsers, {userId})");
        FeedIterator<Chat> chatsIterator = this._chatContainer.GetItemQueryIterator<Chat>(queryDefinition);

        List<MessageDTO> messageDTOs = new();

        while (chatsIterator.HasMoreResults) {
            FeedResponse<Chat> response = await chatsIterator.ReadNextAsync();
            List<Chat> chats = response.ToList();

            foreach (Chat chat in chats) {
                // Consultará e buscará apenas a última mensagem da conversa
                foreach (Message message in chat.Messages) {
                    QueryDefinition lastMessageQuery = new($"SELECT m.messageId, m.sentByUserId, m.content, m.sentAt FROM m WHERE m.messageId = \"{message.MessageId}\"");
                    FeedIterator<Message> lastMessageIterator = this._messageContainer.GetItemQueryIterator<Message>(lastMessageQuery);
                    FeedResponse<Message> lastMessageResponse = await lastMessageIterator.ReadNextAsync();
                    Message completeMessage = lastMessageResponse.Single();
                    message.Content = completeMessage.Content;
                    message.SentByUserId = completeMessage.SentByUserId;
                    message.SentAt = completeMessage.SentAt;

                    messageDTOs.Add(new() {
                        Content = message.Content,
                        MessageId = message.MessageId,
                        IsSentByMe = message.SentByUserId == userId,
                        SentAt = message.SentAt
                    });
                }
            }
        }

        return messageDTOs;
    }

    public async Task AddMessageAsync(Data.Write.Message message, long friendId) {
        QueryDefinition queryDefinition = new($"SELECT c.id, c.chatId, c.relatedUsers, c.messages FROM c WHERE ARRAY_CONTAINS(c.relatedUsers, {message.SentByUserId}) and ARRAY_CONTAINS(c.relatedUsers, {friendId})");
        FeedIterator<Data.Write.Chat> chatsIterator = this._chatContainer.GetItemQueryIterator<Data.Write.Chat>(queryDefinition);
        Data.Write.Chat chat = new();

        while (chatsIterator.HasMoreResults) {
            FeedResponse<Data.Write.Chat> response = await chatsIterator.ReadNextAsync();
            chat = response.Single();
        }

        chat.Messages.Add(new() {
            MessageId = message.MessageId
        });

        await this._messageContainer.CreateItemAsync(message);
        await this._chatContainer.UpsertItemAsync(chat);
    }
}