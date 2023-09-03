using FluentValidation.Results;
using Sonorus.AccountAPI.DTO;

namespace Sonorus.AccountAPI.Extensions;

public static class ValidationResultExtension {
    public static List<FormErrorDTO> ToFormErrorsDTO(this ValidationResult result) => result.Errors.Select(
        error => new FormErrorDTO { Error = error.ErrorMessage, Field = error.FormattedMessagePlaceholderValues.First(item => item.Key.ToString() == "PropertyName").Value.ToString()! }
    ).ToList();
}