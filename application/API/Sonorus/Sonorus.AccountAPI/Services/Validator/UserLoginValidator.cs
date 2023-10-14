using FluentValidation;
using Sonorus.AccountAPI.DTO;

namespace Sonorus.AccountAPI.Services.Validator;

public class UserLoginValidator : AbstractValidator<UserLoginDTO> {
    public UserLoginValidator() {
        RuleFor(user => user).Custom((user, context) => {
            if (user.Email is null && user.Nickname is null)
                context.AddFailure("Informe pelo menos o seu e-mail ou seu apelido.");

            if (user.Email is not null && user.Nickname is not null && user.Email != user.Nickname)
                context.AddFailure("Informe apenas o seu e-mail ou o seu apelido.");
        });

        RuleFor(user => user.Email)
            .NotNull().WithName("login").WithMessage("Informe o seu apelido ou e-mail.")
            .MaximumLength(100).WithMessage("O e-mail não pode exceder 100 caracteres.")
            .EmailAddress().WithMessage("Informe um e-mail válido.")
            .When(user => user.Nickname is null && user.Email is not null);

        RuleFor(user => user.Nickname)
            .NotNull().WithName("login").WithMessage("O apelido precisa ser informado.")
            .MinimumLength(7).WithMessage("O apelido precisa ter no mínimo 7 caracteres.")
            .MaximumLength(25).WithMessage("O apelido pode ter no máximo 25 caracteres.")
            .Matches("^[a-z0-9.]{1,25}$").WithMessage("O apelido deve conter apenas pontos, números e letras minúsculas de A à Z sem acentos.")
            .When(user => user.Email is null && user.Nickname is not null);

        RuleFor(user => user.Password)
            .NotNull().WithName("password").WithMessage("A senha precisa ser informada.")
            .MinimumLength(6).WithMessage("A senha precisa ter no mínimo 6 caracteres.");
    }
}