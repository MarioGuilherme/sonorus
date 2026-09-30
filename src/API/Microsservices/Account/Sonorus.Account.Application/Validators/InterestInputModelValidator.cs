using FluentValidation;
using Sonorus.Account.Application.Commands.AssociateCollectionOfInterests;

namespace Sonorus.Account.Application.Validators;

public class InterestInputModelValidator : AbstractValidator<InterestInputModel>
{
    public InterestInputModelValidator()
    {
        RuleLevelCascadeMode = CascadeMode.Stop;

        RuleFor(i => i.InterestId)
            .GreaterThan(-1)
            .WithMessage("O identificador do interesse está inválido!");

        RuleFor(i => i.Key)
            .MaximumLength(60)
            .WithMessage("A chave identificadora deve ter no máximo 60 caracteres!")
            .When(i => i.Key is not null);

        RuleFor(i => i.Value)
            .MaximumLength(60).WithMessage("O valor deve ter no máximo 60 caracteres!")
            .When(i => i.Key is not null);

        RuleFor(i => i.Type)
            .NotEmpty().WithMessage("O tipo do interesse precisa se informado!")
            .IsInEnum().WithMessage("O tipo do interesse está inválido!");
    }
}