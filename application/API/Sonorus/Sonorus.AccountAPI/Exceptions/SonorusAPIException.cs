using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Exceptions;

public class AccountAPIException : Exception {
    public int StatusCode { get; }
    public List<FieldError>? Errors { get; }

    public AccountAPIException(string message, int statusCode, List<FieldError>? errors = null) : base(message) {
        this.StatusCode = statusCode;
        this.Errors = errors;
    }
}