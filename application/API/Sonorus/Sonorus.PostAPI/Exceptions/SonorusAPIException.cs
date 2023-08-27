namespace Sonorus.PostAPI.Exceptions;

public class PostAPIException : Exception {
    public int StatusCode { get; }

    public PostAPIException(string message, int statusCode) : base(message) => this.StatusCode = statusCode;
}