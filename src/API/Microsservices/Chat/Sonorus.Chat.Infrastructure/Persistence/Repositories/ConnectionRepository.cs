using Microsoft.Azure.Cosmos;
using Sonorus.Chat.Core.Entities;
using Sonorus.Chat.Core.Repositories;
using Sonorus.Chat.Infrastructure.Persistence.AntiCorruption;

namespace Sonorus.Chat.Infrastructure.Persistence.Repositories;

public class ConnectionRepository(Database database) : IConnectionRepository {
    private readonly Container _container = database.CreateContainerIfNotExistsAsync("Connections", "/userId").GetAwaiter().GetResult()!;

    public Task DeleteAsync(Connection connection) => this._container.DeleteItemAsync<CosmosConnection>(connection.Id.ToString(), new(connection.UserId));

    public async Task<Connection?> GetByUserIdAsync(long userId) {
        QueryDefinition queryDefinition = new(@$"SELECT c.id, c.connectionId, c.userId FROM c WHERE c.userId = {userId}");
        using FeedIterator<CosmosConnection> connectionsIterator = this._container.GetItemQueryIterator<CosmosConnection>(queryDefinition);
        FeedResponse<CosmosConnection> response = await connectionsIterator.ReadNextAsync();
        CosmosConnection? cosmosConnection = response.FirstOrDefault();

        if (cosmosConnection is null) return null;

        return new Connection(new(cosmosConnection.Id), cosmosConnection.ConnectionId, cosmosConnection.UserId);
    }

    public async Task<ICollection<string>> GetConnectionIdByParticipantsIdAsync(IEnumerable<long> participants) {
        QueryDefinition queryDefinition = new(@$"
            SELECT c.connectionId FROM c
            WHERE {string.Join(" OR ", participants.Select(userId => $"c.userId = {userId}"))}
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

    public Task RegisterConnectionIdOfUserIdAsync(long userId, string connectionId) => this._container.CreateItemAsync(new CosmosConnection {
        Id = Guid.NewGuid().ToString(),
        UserId = userId,
        ConnectionId = connectionId
    });

    public Task UpdateAsync(Connection connection) => this._container.ReplaceItemAsync(new CosmosConnection {
        Id = connection.Id.ToString(),
        UserId = connection.UserId,
        ConnectionId = connection.ConnectionId
    }, connection.Id.ToString(), new PartitionKey(connection.UserId));
}