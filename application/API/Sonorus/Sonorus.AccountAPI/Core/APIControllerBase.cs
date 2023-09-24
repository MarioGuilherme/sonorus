using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Primitives;
using Sonorus.AccountAPI.Data;
using System.IdentityModel.Tokens.Jwt;

namespace Sonorus.AccountAPI.Core;

public abstract class APIControllerBase : Controller {
    public User? TokenUser { get; set; }

    public override void OnActionExecuting(ActionExecutingContext context) {
        bool isAuthenticated = HttpContext?.User?.Identity?.IsAuthenticated ?? false;

        if (isAuthenticated) {
            HttpContext!.Request.Headers.TryGetValue("Authorization", out StringValues accessToken);
            int idUser = int.Parse(new JwtSecurityToken(accessToken.ToString().Split(' ').Last()).Claims.First(c => c.Type == "IdUser").Value);
            TokenUser = new() { IdUser = idUser };
        }

        base.OnActionExecuting(context);
    }
}