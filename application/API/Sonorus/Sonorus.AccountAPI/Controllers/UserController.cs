using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.AccountAPI.Core;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Services.Interfaces;

namespace Sonorus.AccountAPI.Controllers;

[ApiController]
[Route("api/v1/users")]
public class UserController : APIControllerBase {
    private readonly IUserService _userService;

    public UserController(IUserService userService) => this._userService = userService;

    [Authorize]
    [HttpPost("picture", Name = "SavePicture")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<object>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult> SavePicture(IFormFile picture) {
        RestResponse<object> response = new();
        try {
            await this._userService.SavePicture((long) this.TokenUser!.IdUser!, picture);
            return this.NoContent();
        } catch (AccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpPost("interests", Name = "SaveInterests")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<object>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult> SaveInterests(List<InterestDTO> interests) {
        RestResponse<object> response = new();
        try {
            await this._userService.SaveInterests((long) this.TokenUser!.IdUser!, interests);
            return this.NoContent();
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