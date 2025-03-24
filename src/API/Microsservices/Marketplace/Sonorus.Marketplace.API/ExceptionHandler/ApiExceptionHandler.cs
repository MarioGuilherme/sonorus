using Microsoft.AspNetCore.Diagnostics;
using Sonorus.Marketplace.Core.Exceptions;

namespace Sonorus.Marketplace.API.ExceptionHandler;

public class ApiExceptionHandler(ILogger<ApiExceptionHandler> logger) : IExceptionHandler {
    private readonly ILogger<ApiExceptionHandler> _logger = logger;

    public ValueTask<bool> TryHandleAsync(HttpContext httpContext, Exception exception, CancellationToken cancellationToken) {
        httpContext.Response.StatusCode = exception switch {
            AuthenticatedUserAreNotOwnerOfProductException => StatusCodes.Status403Forbidden,
            ProductNotFoundException => StatusCodes.Status404NotFound,
            _ => StatusCodes.Status500InternalServerError
        };

        this._logger.LogError("{Message}", exception.Message);

        return ValueTask.FromResult(true);
    }
}