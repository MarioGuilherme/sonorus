using Microsoft.AspNetCore.Diagnostics;
using Sonorus.Account.Core.Exceptions;

namespace Sonorus.Account.API.ExceptionHandler;

public class ApiExceptionHandler(ILogger<ApiExceptionHandler> logger) : IExceptionHandler {
    private readonly ILogger<ApiExceptionHandler> _logger = logger;

    public ValueTask<bool> TryHandleAsync(HttpContext httpContext, Exception exception, CancellationToken cancellationToken) {
        httpContext.Response.StatusCode = exception switch {
            AuthenticatedUserNoLongerExistException or RefreshTokenNotFoundByUserException => StatusCodes.Status401Unauthorized,
            UserNotFoundException or InterestNotFoundException => StatusCodes.Status404NotFound,
            EmailAlreadyInUseException or NicknameAlreadyInUseException => StatusCodes.Status409Conflict,
            _ => StatusCodes.Status500InternalServerError,
        };

        this._logger.LogError("{Message}", exception.Message);

        return ValueTask.FromResult(true);
    }
}