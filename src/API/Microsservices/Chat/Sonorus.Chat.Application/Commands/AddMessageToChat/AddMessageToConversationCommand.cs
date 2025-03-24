using MediatR;

namespace Sonorus.Chat.Application.Commands.AddMessageToChat;

public class AddMessageToChatCommand(long sentByUserId, AddMessageToChatInputModel inputModel) : IRequest<IEnumerable<string>> {
    public long SentByUserId { get; private set; } = sentByUserId;
    public Guid ChatId { get; private set; } = string.IsNullOrWhiteSpace(inputModel.ChatId) ? Guid.NewGuid() : new(inputModel.ChatId);
    public IEnumerable<long> Participants { get; private set; } = inputModel.Participants;
    public string Content { get; private set; } = inputModel.Content;
    public DateTime SentAt { get; private set; } = DateTime.Now;
}