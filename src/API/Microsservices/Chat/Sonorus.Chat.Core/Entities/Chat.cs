namespace Sonorus.Chat.Core.Entities;

public class Chat(Guid id, Guid chatId, ICollection<Message> messages, IEnumerable<long> participants) {
    public Guid Id { get; private set; } = id;
    public Guid ChatId { get; private set; } = chatId;
    public ICollection<Message> Messages { get; private set; } = messages;
    public IEnumerable<long> Participants { get; private set; } = participants;
}