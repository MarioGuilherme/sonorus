using FluentValidation;
using Sonorus.Business.Application.Commands.UpdateOpportunity;

namespace Sonorus.Business.Application.Validators;

public class UpdateOpportunityInputModelValidator : AbstractValidator<UpdateOpportunityInputModel> {
    public UpdateOpportunityInputModelValidator() {
        RuleLevelCascadeMode = CascadeMode.Stop;

        RuleFor(o => o.Name)
            .NotEmpty().WithMessage("O nome da oportunidade é obrigatório!")
            .MaximumLength(50).WithMessage("O nome da oportunidade deve ter no máximo 50 caracteres!");

        RuleFor(o => o.BandName)
            .MaximumLength(50).WithMessage("O nome da banda deve ter no máximo 50 caracteres!")
            .When(o => o.BandName is not null);

        RuleFor(o => o.Description)
            .MaximumLength(255).WithMessage("A descrição da oportunidade deve ter no máximo 255 caracteres!")
            .When(o => o.Description is not null);

        RuleFor(o => o.ExperienceRequired)
            .NotEmpty().WithMessage("A experiência requerida para a oportunidade é obrigatória!")
            .MaximumLength(255).WithMessage("A experiência requerida para a oportunidade deve ter no máximo 25 caracteres!");

        RuleFor(o => o.Payment)
            .NotNull().WithMessage("O valor de pagamento para a oportunidade deve ser informado")
            .GreaterThan(0).WithMessage($"O valor de pagamento para a oportunidade não pode ser igual a {0:C2)}!");

        RuleFor(o => o.IsWork)
            .NotNull().WithMessage("Você precisa informar se a vaga é um trabalho para participar de banda ou não!");

        RuleFor(o => o.WorkTimeUnit)
            .IsInEnum().WithMessage("A unidade de tempo de trabalho está inválida!")
            .When(o => o.WorkTimeUnit is not null);
    }
}