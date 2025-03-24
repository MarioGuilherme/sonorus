using FluentValidation;
using Sonorus.Chat.Application.Commands.AddMessageToChat;

namespace Sonorus.Chat.Application.Validators;

public class AddMessageToChatCommandValidator : AbstractValidator<AddMessageToChatCommand> {
    public AddMessageToChatCommandValidator() {
        this.RuleLevelCascadeMode = CascadeMode.Stop;

        this.RuleFor(m => m.SentByUserId)
            .GreaterThan(0).WithMessage("O identificador do usuário responsável pela mensagem não é válido!");

        this.RuleFor(m => m.Participants)
            .Must(participants => participants is not null || participants?.Count() >= 2)
            .WithMessage("O número de participantes da conversa deve ser de pelo menos duas pessoas!");

        this.RuleForEach(m => m.Participants).ChildRules(participants => {
            participants.RuleFor(participantId => participantId)
                .NotEmpty().WithMessage("O identificador do participante da conversa não é válido!");
        });

        this.RuleFor(m => m.Content)
            .NotEmpty().WithMessage("A mensagem não pode ser vazia!")
            .MaximumLength(2500).WithMessage("A mensagem não pode ter mais de 2500 caracteres!");
    }
}