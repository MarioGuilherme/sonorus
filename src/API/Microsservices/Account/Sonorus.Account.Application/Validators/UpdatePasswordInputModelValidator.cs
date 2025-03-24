using FluentValidation;
using Sonorus.Account.Application.Commands.UpdatePassword;

namespace Sonorus.Account.Application.Validators;

public class UpdatePasswordInputModelValidator : AbstractValidator<UpdatePasswordInputModel> {
    public UpdatePasswordInputModelValidator() {
        this.RuleLevelCascadeMode = CascadeMode.Stop;

        this.RuleFor(user => user.Password)
            .NotNull().WithMessage("A senha precisa ser informada!")
            .MinimumLength(6).WithMessage("A senha precisa ter no mínimo 6 caracteres!");
    }
}