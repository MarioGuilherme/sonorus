using Sonorus.AccountAPI.DTO;

namespace Sonorus.AccountAPI.Exceptions;

public class AccountAPIException : Exception {
    public int StatusCode { get; }
    public List<FormErrorDTO>? Errors { get; }

    public AccountAPIException(string message, int statusCode, List<FormErrorDTO>? errors = null) : base(message) {
        this.StatusCode = statusCode;
        this.Errors = errors;
    }
}