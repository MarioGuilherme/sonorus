using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;

namespace Sonorus.SharedKernel;

public class ValidationFilter : IActionFilter {
    public void OnActionExecuted(ActionExecutedContext context) { }

    public void OnActionExecuting(ActionExecutingContext context) {
        if (context.ModelState.IsValid) return;

        IEnumerable<dynamic> errors = context.ModelState
            .Where(e => e.Value!.Errors.Count > 0)
            .Select(ms => {
                string name = ms.Key.Split('[').First();
                return new {
                    field = char.ToLowerInvariant(name[0]) + name[1..],
                    errors = ms.Value?.Errors.Select(e => e.ErrorMessage)
                };
            });

        context.Result = new BadRequestObjectResult(errors);
    }
}