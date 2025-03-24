using Sonorus.Chat.Core.Entities;

namespace Sonorus.Chat.Core.Repositories;

public interface IConnectionRepository {
    Task DeleteAsync(Connection connection);
    Task<Connection?> GetByUserIdAsync(long userId);
    Task<ICollection<string>> GetConnectionIdByParticipantsIdAsync(IEnumerable<long> participants);
    Task RegisterConnectionIdOfUserIdAsync(long userId, string connectionId);
    Task UpdateAsync(Connection connection);
}