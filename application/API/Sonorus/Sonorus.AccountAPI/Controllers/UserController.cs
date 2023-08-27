using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.AccountAPI.Configuration;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Services.Interfaces;
using System.IdentityModel.Tokens.Jwt;
using System.Net;

namespace Sonorus.AccountAPI.Controllers;

[ApiController]
[Route("api/v1")]
public class UserController : APIControllerBase {
    private readonly IUserService _userService;

    public UserController(IUserService userService) => this._userService = userService;

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
            response.Data = await this._userService.Register(userRegister);
            return this.Created(string.Empty, response);
        } catch (AccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        }
    }

    [Authorize]
    [HttpPost("saveInterests", Name = "SaveInterests")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult> SaveInterests(List<InterestDTO> interests) {
        try {
            await this._userService.SaveInterests((long) this.TokenUser.IdUser!, interests);
            return this.NoContent();
        } catch (AccountAPIException exception) {
            RestResponse<object> response = new() {
                Message = exception.Message,
                Errors = exception.Errors
            };
            return this.StatusCode(exception.StatusCode, response);
        }
    }

    [Authorize]
    [HttpPost("savePicture", Name = "SavePicture")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult> SavePicture(IFormFile picture) {
        try {
            await this._userService.SavePicture((long) this.TokenUser.IdUser!, picture);
            return this.NoContent();
        } catch (AccountAPIException exception) {
            RestResponse<object> response = new() {
                Message = exception.Message,
                Errors = exception.Errors
            };
            return this.StatusCode(exception.StatusCode, response);
        }
    }
}