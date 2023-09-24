using FluentValidation;
using Sonorus.AccountAPI.DTO;

namespace Sonorus.AccountAPI.Services.Validator;

public class UserRegisterValidator : AbstractValidator<UserRegisterDTO> {
    public UserRegisterValidator() {
        RuleFor(user => user.FullName)
            .NotNull().WithName("fullname").WithMessage("O nome precisa ser informado.")
            .MaximumLength(100).WithMessage("O nome não pode exceder 100 caracteres.");

        RuleFor(user => user.Email)
            .NotNull().WithName("email").WithMessage("O e-mail precisa ser informado.")
            .MaximumLength(100).WithMessage("O e-mail não pode exceder 100 caracteres.")
            .EmailAddress().WithMessage("Informe um e-mail válido.");

        RuleFor(user => user.Nickname)
            .NotNull().WithName("nickname").WithMessage("O apelido precisa ser informado.")
            .MinimumLength(7).WithMessage("O apelido precisa ter no mínimo 7 caracteres.")
            .MaximumLength(25).WithMessage("O apelido pode ter no máximo 25 caracteres.")
            .Matches("^[a-z0-9.]{7,25}$").WithMessage("O apelido deve conter apenas pontos, números e letras minúsculas sem acentos.");

        RuleFor(user => user.Password)
            .NotNull().WithName("password").WithMessage("A senha precisa ser informada.")
            .MinimumLength(6).WithMessage("A senha precisa ter no mínimo 6 caracteres.");
    }
}