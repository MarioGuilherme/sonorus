using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.Business.Application.Commands.CreateOpportunity;
using Sonorus.Business.Application.Commands.DeleteOpportunity;
using Sonorus.Business.Application.Commands.UpdateOpportunity;
using Sonorus.Business.Application.Queries.GetAllOpportunitiesByName;
using Sonorus.Business.Application.ViewModels;
using Sonorus.SharedKernel;

namespace Sonorus.Business.API.Controllers;

[Authorize]
[ApiController]
[Route("api/v2/opportunities")]
public class OpportunitiesController(IMediator mediator) : ControllerBase
{
    private readonly IMediator _mediator = mediator;

    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetAllWithQuery(string? name = default)
    {
        GetAllOpportunitiesByNameQuery getAllOpportunitiesQuery = new(name);
        IEnumerable<OpportunityViewModel> opportunities = await _mediator.Send(getAllOpportunitiesQuery);
        return Ok(opportunities);
    }

    [HttpPost]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> Create(CreateOpportunityInputModel inputModel)
    {
        CreateOpportunityCommand createOpportunityCommand = new(User.UserId(), inputModel);
        OpportunityViewModel opportunity = await _mediator.Send(createOpportunityCommand);
        return Created(string.Empty, opportunity);
    }

    [HttpPatch("{opportunityId}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> Update(long opportunityId, UpdateOpportunityInputModel inputModel)
    {
        UpdateOpportunityCommand updateOpportunityCommand = new(User.UserId(), opportunityId, inputModel);
        OpportunityViewModel opportunity = await _mediator.Send(updateOpportunityCommand);
        return Ok(opportunity);
    }

    [HttpDelete("{opportunityId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> DeleteById(long opportunityId)
    {
        DeleteOpportunityCommand deleteOpportunityCommand = new(User.UserId(), opportunityId);
        await _mediator.Send(deleteOpportunityCommand);
        return NoContent();
    }
}