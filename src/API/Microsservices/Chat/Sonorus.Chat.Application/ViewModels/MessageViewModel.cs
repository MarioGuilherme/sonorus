namespace Sonorus.Chat.Application.ViewModels;

public record MessageViewModel(string Content, long SentByUserId, DateTime SentAt);