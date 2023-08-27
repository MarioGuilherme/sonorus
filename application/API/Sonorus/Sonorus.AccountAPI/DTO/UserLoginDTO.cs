using FluentValidation;

namespace Sonorus.AccountAPI.DTO;

public class UserLoginDTO {
    public string? Email { get; set; }
    public string? Nickname { get; set; }
    public string? Password { get; set; }
}

public class UserLoginDTOValidator : AbstractValidator<UserLoginDTO> {
    public UserLoginDTOValidator() {
        RuleFor(user => user).Custom((user, context) => {
            if (user.Email is null && user.Nickname is null)
                context.AddFailure("Informe pelo menos o seu e-mail ou seu apelido");

            if (user.Email is not null && user.Nickname is not null)
                context.AddFailure("Informe apenas o seu e-mail ou o seu apelido");
        });

        RuleFor(user => user.Email)
            .NotNull().WithMessage("O e-mail precisa ser informado")
            .MaximumLength(100).WithMessage("O e-mail não pode exceder 100 caracteres")
            .EmailAddress().WithMessage("Informe um e-mail válido")
            .When(user => user.Nickname is null && user.Email is not null);

        RuleFor(user => user.Nickname)
            .NotNull().WithMessage("O apelido precisa ser informado")
            .MinimumLength(7).WithMessage("O apelido precisa ter no mínimo 7 caracteres")
            .MaximumLength(25).WithMessage("O apelido pode ter no máximo 25 caracteres")
            .Matches("^[a-z0-9.]{1,25}$").WithMessage("O apelido deve conter apenas letras minúsculas de A à Z sem acentos, pontos e números")
            .When(user => user.Email is null && user.Nickname is not null);

        RuleFor(user => user.Password)
            .NotNull().WithMessage("A senha precisa ser informada")
            .MinimumLength(6).WithMessage("A senha precisa ter no mínimo 6 caracteres");
    }
}