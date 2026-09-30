using FluentValidation;
using Sonorus.Account.Application.Commands.AssociateCollectionOfInterests;

namespace Sonorus.Account.Application.Validators;

public class AssociateInterestsInputModelValidator : AbstractValidator<AssociateCollectionOfInterestsInputModel> {
    public AssociateInterestsInputModelValidator() {
        RuleLevelCascadeMode = CascadeMode.Stop;

        RuleFor(user => user.Interests)
            .NotNull().NotEmpty().WithMessage("A lista de interesses precisa ser informada!")
            .ForEach(interest => {
                interest.Must(i => i.InterestId != 0 || !string.IsNullOrEmpty(i.Key))
                    .WithMessage("A chave do interesse precisa ser informada!");

                interest.Must(i => i.InterestId != 0 || !string.IsNullOrEmpty(i.Value))
                    .WithMessage("O nome do interesse precisa ser informado!");

                interest.Must(i => i.InterestId != 0 || Enum.IsDefined(i.Type))
                    .WithMessage("O tipo do interesse precisa ser Banda, Artista, Gênero Musical ou Habilidade!");
            });
    }
}