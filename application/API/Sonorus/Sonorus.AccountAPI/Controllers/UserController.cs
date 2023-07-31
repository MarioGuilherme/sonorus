using Microsoft.AspNetCore.Mvc;
using Sonorus.AccountAPI.Configuration;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Services.Interfaces;
using System;

namespace Sonorus.AccountAPI.Controllers;

[ApiController]
[Route("api/v1/users")]
public class UserController : ControllerBase {
    private readonly IUserService _userService;

    public UserController(IUserService userService) => this._userService = userService;

    [HttpPost("login", Name = "Login")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<RestResponse<UserDTO>>> Login(UserDTO user) {
        RestResponse<UserDTO> response = new();
        try {
            response.Data = await this._userService.Login(user.Email, user.Nickname, user.Password);
            return this.Ok(response);
        } catch (SonorusAPIException exception) {
            response.Message = exception.Message;
            return this.StatusCode(exception.StatusCode, response);
        }
    }

    [HttpPost("register", Name = "Register")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    public async Task<ActionResult<RestResponse<UserDTO>>> Register(UserDTO user) {
        RestResponse<UserDTO> response = new();
        try {
            response.Data = await this._userService.Register(user);
            return this.Created(string.Empty, response.Data);
        } catch (SonorusAPIException exception) {
            response.Message = exception.Message;
            return this.StatusCode(exception.StatusCode, response);
        }
    }
}