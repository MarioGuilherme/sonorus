using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Exceptions;

public class SonorusPostAPIException : Exception {
    public int StatusCode { get; }
    public List<FieldError>? Errors { get; }

    public SonorusPostAPIException(string message, int statusCode, List<FieldError>? errors = null) : base(message) {
        this.StatusCode = statusCode;
        this.Errors = errors;
    }
}