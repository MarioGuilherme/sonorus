using System.Security.Claims;

namespace Sonorus.SharedKernel;

public static class UserExtensions {
    public static long UserId(this ClaimsPrincipal principal) => long.Parse(principal.Claims.First(c => c.Type == "UserId").Value);
}