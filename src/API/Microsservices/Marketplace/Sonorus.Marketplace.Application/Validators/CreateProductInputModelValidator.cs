using FluentValidation;
using Sonorus.Marketplace.Application.Commands.CreateProduct;

namespace Sonorus.Marketplace.Application.Validators;

public class CreateProductInputModelValidator : AbstractValidator<CreateProductInputModel> {
    private readonly IEnumerable<string> _allowedExtensions = [".png", ".jpeg", ".jpg"];

    public CreateProductInputModelValidator() {
        this.RuleLevelCascadeMode = CascadeMode.Stop;

        this.RuleFor(p => p.Name)
            .NotEmpty().WithMessage("O nome do produto é obrigatório!")
            .MaximumLength(50).WithMessage("O nome do produto deve ter no máximo 50 caracteres!");

        this.RuleFor(p => p.Description)
            .MaximumLength(255).WithMessage("A descrição do produto deve ter no máximo 255 caracteres!")
            .When(p => p.Description is not null);

        this.RuleFor(p => p.Price)
            .NotNull().WithMessage("O valor do produto deve ser informado!")
            .GreaterThan(0).WithMessage($"O valor do produto não pode ser igual a {0:C2)}!");

        this.RuleFor(p => p.Condition)
            .NotNull().WithMessage("A condição do produto é obrigatória!")
            .IsInEnum().WithMessage("A condição do produto deve ser um valor válido!");

        this.RuleFor(p => p.Medias)
            .Must(medias => medias != null && medias.Any())
            .WithMessage("É necessário anexar ao menos uma foto/vídeo!");

        this.RuleForEach(p => p.Medias).ChildRules(medias => {
            medias.RuleFor(media => media)
                .NotEmpty().WithMessage("A imagem precisa ser informada!")
                .Must(file => this._allowedExtensions.Contains(Path.GetExtension(file.FileName)))
                .WithMessage("O tipo de arquivo deve ser png, jpeg ou jpg!")
                .Must(file => file.Length <= 5 * 1024 * 1024)
                .WithMessage("O tamanho do arquivo não pode exceder 5MB!");
        });
    }
}