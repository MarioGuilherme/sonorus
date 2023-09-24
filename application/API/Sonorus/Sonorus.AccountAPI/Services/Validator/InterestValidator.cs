using FluentValidation;
using Sonorus.AccountAPI.DTO;

namespace Sonorus.AccountAPI.Services.Validator;

public class InterestValidator : AbstractValidator<InterestDTO> {
    public InterestValidator() {
        When(interest => interest.IdInterest is null, () => {
            RuleFor(user => user.Key)
                .NotNull().WithMessage("A tag do interesse precisa ser informado")
                .MaximumLength(60).WithMessage("A chave tag do interesse não pode exceder 60 caracteres");

            RuleFor(user => user.Value)
                .NotNull().WithMessage("O interesse precisa ser informado")
                .MaximumLength(60).WithMessage("O interesse não pode exceder 60 caracteres");

            RuleFor(user => user.Type).IsInEnum().WithMessage("O tipo do interesse precisa ser Bamda, Genêro Musical ou Habilidade");
        });
    }
}