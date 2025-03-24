namespace Sonorus.Chat.Core.Entities;

public class Message(string content, long sentByUserId, DateTime sentAt) {
    public string Content { get; private set; } = content;
    public long SentByUserId { get; private set; } = sentByUserId;
    public DateTime SentAt { get; private set; } = sentAt;
}