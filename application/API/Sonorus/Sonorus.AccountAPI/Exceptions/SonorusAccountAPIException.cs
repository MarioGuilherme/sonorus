using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Exceptions;

public class SonorusAccountAPIException : Exception {
    public int StatusCode { get; }
    public List<FieldError>? Errors { get; }

    public SonorusAccountAPIException(string message, int statusCode, List<FieldError>? errors = null) : base(message) {
        this.StatusCode = statusCode;
        this.Errors = errors;
    }
}