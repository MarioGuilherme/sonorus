using Microsoft.AspNetCore.Mvc;
using Sonorus.AccountAPI.Core;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Services.Interfaces;

namespace Sonorus.AccountAPI.Controllers;

[ApiController]
[Route("api/v1/auth")]
public class AuthController : APIControllerBase {
    private readonly IUserService _userService;

    public AuthController(IUserService userService) => this._userService = userService;

    [HttpPost("login", Name = "Login")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<AuthToken>))]
    [ProducesResponseType(StatusCodes.Status404NotFound, Type = typeof(RestResponse<AuthToken>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<AuthToken>))]
    public async Task<ActionResult<RestResponse<AuthToken>>> Login(UserLoginDTO userLogin) {
        RestResponse<AuthToken> response = new();
        try {
            response.Data = await this._userService.Login(userLogin);
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

    [HttpPost("register", Name = "Register")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict, Type = typeof(RestResponse<AuthToken>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<AuthToken>))]
    public async Task<ActionResult<RestResponse<AuthToken>>> Register(UserRegisterDTO userRegister) {
        RestResponse<AuthToken> response = new();
        try {
            response.Data = await this._userService.Register(userRegister);
            return this.Created(string.Empty, response);
        } catch (SonorusAccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }
}