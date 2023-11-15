using Sonorus.BusinessAPI.Models;

namespace Sonorus.BusinessAPI.Exceptions;

public class SonorusBusinessAPIException : Exception {
    public int StatusCode { get; }
    public List<FieldError>? Errors { get; }

    public SonorusBusinessAPIException(string message, int statusCode, List<FieldError>? errors = null) : base(message) {
        this.StatusCode = statusCode;
        this.Errors = errors;
    }
}