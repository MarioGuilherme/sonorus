namespace Sonorus.Chat.Application.Commands.AddMessageToChat;

public class AddMessageToChatInputModel(string? chatId, string? messageId, IEnumerable<long> participants, string content) {
    public string? ChatId { get; private set; } = chatId;
    public string? MessageId { get; private set; } = messageId;
    public IEnumerable<long> Participants { get; private set; } = participants;
    public string Content { get; private set; } = content;
}