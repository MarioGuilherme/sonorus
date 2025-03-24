using FluentValidation;
using Sonorus.Post.Application.Commands.CreateComment;

namespace Sonorus.Post.Application.Validators;

public class CreateCommentInputModelValidator : AbstractValidator<CreateCommentInputModel> {
    public CreateCommentInputModelValidator() {
        this.RuleLevelCascadeMode = CascadeMode.Stop;

        this.RuleFor(c => c.Content)
            .NotEmpty().WithMessage("O conteúdo do comentário não pode está vazio!")
            .MaximumLength(100).WithMessage("O conteúdo do comentário não pode exceder 100 caracteres!");
    }
}