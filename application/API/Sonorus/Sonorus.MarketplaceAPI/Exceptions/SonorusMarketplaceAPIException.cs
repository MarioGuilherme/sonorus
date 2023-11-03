using Sonorus.MarketplaceAPI.Models;

namespace Sonorus.MarketplaceAPI.Exceptions;

public class SonorusMarketplaceAPIException : Exception {
    public int StatusCode { get; }
    public List<FieldError>? Errors { get; }

    public SonorusMarketplaceAPIException(string message, int statusCode, List<FieldError>? errors = null) : base(message) {
        this.StatusCode = statusCode;
        this.Errors = errors;
    }
}