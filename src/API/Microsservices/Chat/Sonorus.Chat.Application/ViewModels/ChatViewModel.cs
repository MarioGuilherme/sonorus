namespace Sonorus.Chat.Application.ViewModels;

public record ChatViewModel(Guid ChatId, IEnumerable<MessageViewModel> Messages) {
    public IEnumerable<UserViewModel> Participants { get; set; } = null!;
}