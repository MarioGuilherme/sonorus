using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.BusinessAPI.Core;
using Sonorus.BusinessAPI.DTO;
using Sonorus.BusinessAPI.Exceptions;
using Sonorus.BusinessAPI.Models;
using Sonorus.BusinessAPI.Services.Interfaces;

namespace Sonorus.BusinessAPI.Controllers;

[ApiController]
[Route("api/v1/users")]
public class UserController : APIControllerBase {
    private readonly IOpportunityService _opportunityService;

    public UserController(IOpportunityService opportunityService) => this._opportunityService = opportunityService;

    [HttpGet("{userId}/opportunities")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<List<OpportunityDTO>>))]
    [ProducesResponseType(StatusCodes.Status404NotFound, Type = typeof(RestResponse<List<OpportunityDTO>>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<OpportunityDTO>>))]
    public async Task<ActionResult<RestResponse<List<OpportunityDTO>>>> GetOpportunitiesFromUser(long userId) {
        RestResponse<List<OpportunityDTO>> response = new();
        try {
            response.Data = await this._opportunityService.GetAllByUserIdAsync(userId);
            return this.Ok(response);
        } catch (SonorusBusinessAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }
}