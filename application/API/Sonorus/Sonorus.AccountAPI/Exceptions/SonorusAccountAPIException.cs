using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Exceptions;

public class SonorusSonorusAccountAPIException : Exception {
    public int StatusCode { get; }
    public List<FieldError>? Errors { get; }

    public SonorusSonorusAccountAPIException(string message, int statusCode, List<FieldError>? errors = null) : base(message) {
        this.StatusCode = statusCode;
        this.Errors = errors;
    }
}