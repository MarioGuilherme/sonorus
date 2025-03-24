using FluentValidation;
using Sonorus.Post.Application.Commands.UpdatePost;

namespace Sonorus.Post.Application.Validators;

public class UpdatePostInputModelValidator : AbstractValidator<UpdatePostInputModel> {
    private readonly IEnumerable<string> _allowedExtensions = [".png", ".jpeg", ".jpg"];

    public UpdatePostInputModelValidator() {
        this.RuleLevelCascadeMode = CascadeMode.Stop;

        this.RuleFor(p => p.Content)
            .MaximumLength(300).WithMessage("O conteúdo não pode ultrapassar 300 caracteres!")
            .When(p => p.Content is not null);

        this.RuleFor(p => p.Tablature)
            .MaximumLength(8000).WithMessage("A tablatura não pode ultrapassar 8000 caracteres!")
            .When(p => p.Tablature is not null);

        this.RuleForEach(p => p.InterestsIds).ChildRules(interests => {
            interests.RuleFor(interest => interest)
                .GreaterThan(0).WithMessage("O identificador do interesse está inválido!");
        });

        this.RuleForEach(p => p.MediasToRemove).ChildRules(mediasToRemove => {
            mediasToRemove.RuleFor(mediaToRemove => mediaToRemove)
                .GreaterThan(0).WithMessage("O identificador do interesse está inválido!");
        });

        this.RuleForEach(p => p.NewMedias).ChildRules(medias => {
            medias.RuleFor(media => media)
                .Must(file => this._allowedExtensions.Contains(Path.GetExtension(file.FileName)))
                .WithMessage("O tipo de arquivo deve ser png, jpeg ou jpg!")
                .Must(file => file.Length <= 5 * 1024 * 1024)
                .WithMessage("O tamanho do arquivo não pode exceder 5MB!");
        });
    }
}