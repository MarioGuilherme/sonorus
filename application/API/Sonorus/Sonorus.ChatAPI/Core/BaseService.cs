using FluentValidation;
using FluentValidation.Results;
using Sonorus.ChatAPI.Exceptions;
using Sonorus.ChatAPI.Models;

namespace Sonorus.ChatAPI.Core;

public abstract class BaseService {
    public void Validate<TValidator, TInstance>(TInstance instance) {
        ValidationResult resultValidation = ((AbstractValidator<TInstance>) Activator.CreateInstance(typeof(TValidator))!).Validate(instance);

        if (!resultValidation.IsValid)
            throw new SonorusChatAPIException(
                "Alguns campos estão inválidos",
                400,
                resultValidation.Errors.Select(error => new FieldError {
                    Error = error.ErrorMessage,
                    Field = error.FormattedMessagePlaceholderValues.First(item => item.Key.ToString() == "PropertyName").Value.ToString()!
                }).ToList()
            );
    }
}