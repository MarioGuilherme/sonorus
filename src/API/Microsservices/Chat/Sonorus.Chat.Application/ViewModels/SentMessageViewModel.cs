namespace Sonorus.Chat.Application.ViewModels;

public record SentMessageViewModel(Guid ChatId, string? MessageId, DateTime SentAt);