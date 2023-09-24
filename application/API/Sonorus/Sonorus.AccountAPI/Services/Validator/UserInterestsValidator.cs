using FluentValidation;
using Sonorus.AccountAPI.DTO;

namespace Sonorus.AccountAPI.Services.Validator;

public class UserInterestsValidator : AbstractValidator<UserInterestsDTO> {
    public UserInterestsValidator() {
        RuleFor(user => user.IdUser)
            .NotNull().WithMessage("O Id do usuário precisa ser informado")
            .GreaterThanOrEqualTo(1).WithMessage("O Id do usuário precisa ser maior que 0");

        RuleForEach(user => user.Interests).SetValidator(new InterestValidator());
    }
}