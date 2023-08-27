namespace Sonorus.AccountAPI.Exceptions;

public class AccountAPIException : Exception {
    public int StatusCode { get; }
    public dynamic? Errors { get; }

    public AccountAPIException(string message, int statusCode, dynamic? errors = null) : base(message) {
        this.StatusCode = statusCode;
        this.Errors = errors;
    }
}