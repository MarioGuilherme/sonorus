using AutoMapper;
using MediatR;
using Sonorus.Chat.Core.Entities;
using Sonorus.Chat.Core.Repositories;

namespace Sonorus.Chat.Application.Commands.AddMessageToChat;

public class AddMessageToChatCommandHandler(
    IChatRepository chatRepository,
    IConnectionRepository connectionRepository,
    IMapper mapper
) : IRequestHandler<AddMessageToChatCommand, IEnumerable<string>> {
    private readonly IChatRepository _chatRepository = chatRepository;
    private readonly IConnectionRepository _connectionRepository = connectionRepository;
    private readonly IMapper _mapper = mapper;

    public async Task<IEnumerable<string>> Handle(AddMessageToChatCommand request, CancellationToken cancellationToken) {
        Message message = this._mapper.Map<Message>(request);

        Core.Entities.Chat? chat = await this._chatRepository.GetByIdAsync(request.ChatId);

        if (chat is not null) {
            chat!.Messages.Add(message);
            await this._chatRepository.UpdateAsync(chat);
            return await this._connectionRepository.GetConnectionIdByParticipantsIdAsync(chat.Participants.Where(p => p != request.SentByUserId));
        }

        await this._chatRepository.CreateAsync(new(
            Guid.NewGuid(),
            request.ChatId,
            [message],
            request.Participants
        ));
        return await this._connectionRepository.GetConnectionIdByParticipantsIdAsync(request.Participants.Where(p => p != request.SentByUserId));
    }
}
