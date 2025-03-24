using Microsoft.AspNetCore.Http;

namespace Sonorus.SharedKernel;

public static class HttpContextExtensions {
    public static string AccessToken(this HttpContext httpContext) => httpContext.Request.Headers.Authorization.ToString().Split(' ')[1];
}