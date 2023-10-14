using Sonorus.ChatAPI.Models;

namespace Sonorus.ChatAPI.Exceptions;

public class SonorusChatAPIException : Exception {
    public int StatusCode { get; }
    public List<FieldError>? Errors { get; }

    public SonorusChatAPIException(string message, int statusCode, List<FieldError>? errors = null) : base(message) {
        this.StatusCode = statusCode;
        this.Errors = errors;
    }
}