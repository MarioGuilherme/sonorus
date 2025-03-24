using FluentValidation;
using Sonorus.Account.Application.Commands.RegenerateAccessToken;

namespace Sonorus.Account.Application.Validators;

public class RefreshTokenInputModelValidator : AbstractValidator<RefreshTokenInputModel> {
    public RefreshTokenInputModelValidator() {
        this.RuleLevelCascadeMode = CascadeMode.Stop;

        this.RuleFor(rt => rt.RefreshToken)
            .NotEmpty().WithMessage("O token de redefinição do token é obrigatório!")
            .MaximumLength(44).WithMessage("O token de redefinição deve ter no máximo 44 caracteres!");
    }
}