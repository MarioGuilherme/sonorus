using FluentValidation;
using Sonorus.Account.Application.Commands.UpdatePicture;

namespace Sonorus.Account.Application.Validators;

public class SavePictureCommandValidator : AbstractValidator<UpdatePictureCommand> {
    private readonly IEnumerable<string> _allowedExtensions = [".png", ".jpeg", ".jpg"];

    public SavePictureCommandValidator() {
        this.RuleLevelCascadeMode = CascadeMode.Stop;

        this.RuleFor(picture => picture.Picture)
            .NotEmpty().WithMessage("A imagem precisa ser informada!")
            .Must(file => this._allowedExtensions.Contains(Path.GetExtension(file.FileName))).WithMessage("O tipo de arquivo deve ser png, jpeg ou jpg!")
            .Must(file => file.Length <= 5 * 1024 * 1024).WithMessage("O tamanho do arquivo não pode exceder 5MB!");
    }
}