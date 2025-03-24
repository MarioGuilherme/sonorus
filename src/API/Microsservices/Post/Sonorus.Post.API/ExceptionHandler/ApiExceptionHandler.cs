using Microsoft.AspNetCore.Diagnostics;
using Sonorus.Post.Core.Exceptions;

namespace Sonorus.Post.API.ExceptionHandler;

public class ApiExceptionHandler(ILogger<ApiExceptionHandler> logger) : IExceptionHandler {
    private readonly ILogger<ApiExceptionHandler> _logger = logger;

    public ValueTask<bool> TryHandleAsync(HttpContext httpContext, Exception exception, CancellationToken cancellationToken) {
        httpContext.Response.StatusCode = exception switch {
            PostNotFoundException or CommentNotFoundException => StatusCodes.Status404NotFound,
            AuthenticatedUserAreNotOwnerOfPostException or AuthenticatedUserAreNotOwnerOfCommentException => StatusCodes.Status403Forbidden,
            _ => StatusCodes.Status500InternalServerError
        };

        this._logger.LogError("{Message}", exception.Message);

        return ValueTask.FromResult(true);
    }
}