namespace Sonorus.AccountAPI.Exceptions;

public class SonorusAPIException : Exception {
    public int StatusCode { get; }

    public SonorusAPIException(string message, int statusCode) : base(message) => this.StatusCode = statusCode;
}