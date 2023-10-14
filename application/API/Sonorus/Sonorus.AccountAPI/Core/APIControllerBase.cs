using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Primitives;
using Sonorus.AccountAPI.Models;
using System.IdentityModel.Tokens.Jwt;

namespace Sonorus.AccountAPI.Core;

public abstract class APIControllerBase : Controller {
    public CurrentUser? CurrentUser { get; set; }

    public override void OnActionExecuting(ActionExecutingContext context) {
        bool isAuthenticated = HttpContext?.User?.Identity?.IsAuthenticated ?? false;

        if (isAuthenticated) {
            HttpContext!.Request.Headers.TryGetValue("Authorization", out StringValues accessToken);
            int userId = int.Parse(new JwtSecurityToken(accessToken.ToString().Split(' ').Last()).Claims.First(c => c.Type == "UserId").Value);
            this.CurrentUser = new() { UserId = userId };
        }

        base.OnActionExecuting(context);
    }
}