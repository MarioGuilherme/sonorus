using FluentValidation;
using Sonorus.Account.Application.Queries.GetUserByLogin;
using System.Text.RegularExpressions;

namespace Sonorus.Account.Application.Validators;

public partial class GetUserByLoginQueryValidator : AbstractValidator<GetUserByLoginQuery> {
    public GetUserByLoginQueryValidator() {
        this.RuleLevelCascadeMode = CascadeMode.Stop;

        this.RuleFor(user => user.Login)
            .NotEmpty().WithMessage("O seu e-mail ou apelido precisa ser informado!")
            .Must(value => {
                EmailValidator emailValidator = new();
                bool isEmail = emailValidator.Validate(value).IsValid;
                bool isNickname = NicknamePattern().IsMatch(value);

                return isEmail || isNickname;
            }).WithMessage("Deve ser um e-mail válido ou um apelido válido (de 1 à 25 letras, números e underscore)!");

        this.RuleFor(user => user.Password)
            .NotEmpty().WithMessage("A senha precisa ser informada!")
            .MinimumLength(6).WithMessage("A senha precisa ter no mínimo 6 caracteres!");
    }

    public class EmailValidator : AbstractValidator<string> {
        public EmailValidator() => this.RuleFor(x => x).EmailAddress();
    }

    [GeneratedRegex(@"^[a-zA-Z0-9_]+$")]
    public static partial Regex NicknamePattern();
}