using FluentValidation;

namespace Sonorus.AccountAPI.DTO;

public class UserRegisterDTO {
    public string? FullName { get; set; }

    public string? Nickname { get; set; }

    public string? Email { get; set; }

    public string? Password { get; set; }
}

public class UserRegisterDTOValidator : AbstractValidator<UserRegisterDTO> {
    public UserRegisterDTOValidator() {
        RuleFor(user => user.FullName)
            .NotNull().WithMessage("O nome precisa ser informado")
            .MaximumLength(100).WithMessage("O nome não pode exceder 100 caracteres");

        RuleFor(user => user.Email)
            .NotNull().WithMessage("O e-mail precisa ser informado")
            .MaximumLength(100).WithMessage("O e-mail não pode exceder 100 caracteres")
            .EmailAddress().WithMessage("Informe um e-mail válido");

        RuleFor(user => user.Nickname)
            .NotNull().WithMessage("O apelido precisa ser informado")
            .MinimumLength(7).WithMessage("O apelido precisa ter no mínimo 7 caracteres")
            .MaximumLength(25).WithMessage("O apelido pode ter no máximo 25 caracteres")
            .Matches("^[a-z0-9.]{1,25}$").WithMessage("O apelido deve conter apenas letras minúsculas de A à Z sem acentos, pontos e números");

        RuleFor(user => user.Password)
            .NotNull().WithMessage("A senha precisa ser informada")
            .MinimumLength(6).WithMessage("A senha precisa ter no mínimo 6 caracteres");
    }
}