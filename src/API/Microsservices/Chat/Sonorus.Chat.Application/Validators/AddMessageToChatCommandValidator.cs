using FluentValidation;
using Sonorus.Chat.Application.Commands.AddMessageToChat;

namespace Sonorus.Chat.Application.Validators;

public class AddMessageToChatCommandValidator : AbstractValidator<AddMessageToChatCommand> {
    public AddMessageToChatCommandValidator() {
        RuleLevelCascadeMode = CascadeMode.Stop;

        RuleFor(m => m.SentByUserId)
            .GreaterThan(0).WithMessage("O identificador do usuário responsável pela mensagem não é válido!");

        RuleFor(m => m.Participants)
            .Must(participants => participants is not null || participants?.Count() >= 2)
            .WithMessage("O número de participantes da conversa deve ser de pelo menos duas pessoas!");

        RuleForEach(m => m.Participants).ChildRules(participants => {
            participants.RuleFor(participantId => participantId)
                .NotEmpty().WithMessage("O identificador do participante da conversa não é válido!");
        });

        RuleFor(m => m.Content)
            .NotEmpty().WithMessage("A mensagem não pode ser vazia!")
            .MaximumLength(2500).WithMessage("A mensagem não pode ter mais de 2500 caracteres!");
    }
}