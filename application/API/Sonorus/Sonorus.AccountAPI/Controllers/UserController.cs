using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
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

    public UserController(IUserService userService, IInterestService interestService) {
        this._userService = userService;
    }

    [Authorize]
    [HttpPost("picture")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<object>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult> SavePicture(IFormFile picture) {
        RestResponse<object> response = new();
        try {
            await this._userService.SavePictureByUserIdAsync((long) this.CurrentUser!.UserId!, picture);
            return this.NoContent();
        } catch (SonorusAccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpPost("interests")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<object>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult> SaveInterests(List<InterestDTO> interests) {
        RestResponse<object> response = new();
        try {
            await this._userService.SaveInterestsByUserIdAsync((long)this.CurrentUser!.UserId!, interests);
            return this.NoContent();
        } catch (SonorusAccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpGet("interests")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult> GetInterests() {
        RestResponse<object> response = new();
        try {
            response.Data = await this._userService.GetInterestsByUserIdAsync((long)this.CurrentUser!.UserId!);
            return this.Ok(response);
        } catch (SonorusAccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public ActionResult GetRangeOfUsersById() {
        RestResponse<object> response = new();
        try {
            this.HttpContext.Request.Headers.TryGetValue("UserIds", out StringValues usersIdRaw);
            response.Data = this._userService.GetUsersByUserIds(usersIdRaw);
            return this.Ok(response);
        } catch (SonorusAccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }
}