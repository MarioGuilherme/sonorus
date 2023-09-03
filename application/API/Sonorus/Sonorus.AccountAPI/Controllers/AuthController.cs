using Microsoft.AspNetCore.Mvc;
using Sonorus.AccountAPI.Configuration;
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
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<RestResponse<AuthToken>>> Login(UserLoginDTO userLogin) {
        RestResponse<AuthToken> response = new();
        try {
            response.Data = await this._userService.Login(userLogin);
            return this.Ok(response);
        } catch (AccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        }
    }

    [HttpPost("register", Name = "Register")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<RestResponse<AuthToken>>> Register(UserRegisterDTO userRegister) {
        RestResponse<AuthToken> response = new();
        try {
            userRegister.Nickname = "asdasd´sad´sadsa´dsa´dsadásdásdásdásd";
            response.Data = await this._userService.Register(userRegister);
            return this.Created(string.Empty, response);
        } catch (AccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        }
    }
}