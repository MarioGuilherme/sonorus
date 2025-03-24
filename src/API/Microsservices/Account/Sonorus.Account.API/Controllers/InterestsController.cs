using MediatR;
using Microsoft.AspNetCore.Mvc;
using Sonorus.Account.Application.Queries.GetAllInterests;
using Sonorus.Account.Application.ViewModels;

namespace Sonorus.Account.API.Controllers;

[ApiController]
[Route("api/v2/interests")]
public class InterestsController(IMediator mediator) : ControllerBase {
    private readonly IMediator _mediator = mediator;

    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll() {
        GetAllInterestsQuery query = new();
        IEnumerable<InterestViewModel> interests = await this._mediator.Send(query);
        return this.Ok(interests);
    }
}