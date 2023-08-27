using FluentValidation;

namespace Sonorus.AccountAPI.DTO;

public class UserInterestsDTO {
    public long? IdUser { get; set; }

    public List<InterestDTO> Interests { get; set; } = new();
}

public class UserInterestsDTOValidator : AbstractValidator<UserInterestsDTO> {
    public UserInterestsDTOValidator() {
        RuleFor(user => user.IdUser)
            .NotNull().WithMessage("O Id do usuário precisa ser informado")
            .GreaterThanOrEqualTo(1).WithMessage("O Id do usuário precisa ser maior que 0");

        RuleForEach(user => user.Interests).SetValidator(new InterestDTOValidator());
    }
}