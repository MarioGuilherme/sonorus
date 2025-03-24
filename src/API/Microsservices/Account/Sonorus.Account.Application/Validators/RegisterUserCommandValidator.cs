using FluentValidation;
using Sonorus.Account.Application.Commands.CreateUser;

namespace Sonorus.Account.Application.Validators;

public class RegisterUserCommandValidator : AbstractValidator<CreateUserCommand> {
    public RegisterUserCommandValidator() {
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

        this.RuleFor(user => user.Password)
            .NotEmpty().WithMessage("A senha precisa ser informada!")
            .MinimumLength(6).WithMessage("A senha precisa ter no mínimo 6 caracteres!");
    }
}