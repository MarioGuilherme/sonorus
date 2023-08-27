using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Primitives;
using Sonorus.AccountAPI.Models;
using System.IdentityModel.Tokens.Jwt;

namespace Sonorus.AccountAPI.Configuration;

public abstract class APIControllerBase : Controller {
    public User TokenUser { get; set; }

    public override void OnActionExecuting(ActionExecutingContext context) {
        bool isAuthenticated = base.HttpContext?.User?.Identity?.IsAuthenticated ?? false;

        if (isAuthenticated) {
            base.HttpContext.Request.Headers.TryGetValue("Authorization", out StringValues accessToken);
            int idUser = int.Parse(new JwtSecurityToken(accessToken.ToString().Split(' ').Last()).Claims.First(c => c.Type == "IdUser").Value);
            this.TokenUser = new() {
                IdUser = idUser
            };
        }

        base.OnActionExecuting(context);
    }
}