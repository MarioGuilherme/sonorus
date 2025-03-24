using FluentValidation;
using Sonorus.Account.Application.Commands.UpdateUser;

namespace Sonorus.Account.Application.Validators;

public class UpdateUserInputModelValidator : AbstractValidator<UpdateUserInputModel> {
    public UpdateUserInputModelValidator() {
        this.RuleLevelCascadeMode = CascadeMode.Stop;

        this.RuleFor(user => user.Fullname)
            .NotEmpty().WithMessage("O nome precisa ser informado!")
            .MaximumLength(60).WithMessage("O nome não pode exceder 60 caracteres!");

        this.RuleFor(user => user.Email)
            .NotEmpty().WithMessage("O e-mail precisa ser informado!")
            .MaximumLength(60).WithMessage("O e-mail não pode exceder 60 caracteres!")
            .EmailAddress().WithMessage("Informe um e-mail válido!");

        this.RuleFor(user => user.Nickname)
            .NotEmpty().WithMessage("O apelido precisa ser informado!")
            .MinimumLength(7).WithMessage("O apelido precisa ter no mínimo 7 caracteres!")
            .MaximumLength(25).WithMessage("O apelido pode ter no máximo 25 caracteres!")
            .Matches(@"^[a-zA-Z0-9_.]+$").WithMessage("O apelido deve conter apenas pontos, números e letras!");
    }
}