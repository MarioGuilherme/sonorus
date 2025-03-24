namespace Sonorus.Chat.Application.ViewModels;

public record ErrorSendingMessageViewModel(string? MessageId, IEnumerable<string> Errors);