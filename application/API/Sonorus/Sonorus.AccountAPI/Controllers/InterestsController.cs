using Microsoft.AspNetCore.Mvc;
using Sonorus.AccountAPI.Configuration;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Services.Interfaces;

namespace Sonorus.AccountAPI.Controllers;

[ApiController]
[Route("api/v1")]
public class InterestsController : APIControllerBase {
    private readonly IInterestService _interestService;

    public InterestsController(IInterestService interestService) => this._interestService = interestService;

    [HttpGet("interests", Name = "Interests")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<ActionResult<RestResponse<List<InterestDTO>>>> GetAllInterests() {
        RestResponse<List<InterestDTO>> response = new();
        try {
            response.Data = await this._interestService.GetAll();
            return this.Ok(response);
        } catch (AccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        }
    }
}