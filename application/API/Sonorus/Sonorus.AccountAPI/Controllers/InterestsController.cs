using Microsoft.AspNetCore.Mvc;
using Sonorus.AccountAPI.Configuration;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Services.Interfaces;

namespace Sonorus.AccountAPI.Controllers;

[ApiController]
[Route("api/v1/interests")]
public class InterestsController : APIControllerBase {
    private readonly IInterestService _interestService;

    public InterestsController(IInterestService interestService) => this._interestService = interestService;

    [HttpGet(Name = "Interests")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<InterestDTO>>))]
    public async Task<ActionResult<RestResponse<List<InterestDTO>>>> GetAllInterests() {
        RestResponse<List<InterestDTO>> response = new();
        try {
            response.Data = await this._interestService.GetAll();
            return this.Ok(response);
        } catch (AccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }
}