﻿using Microsoft.AspNetCore.Authentication;
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
[Route("api/v1/interest")]
public class UserController : APIControllerBase {
    private readonly IUserService _userService;

    public UserController(IUserService userService) => this._userService = userService;

    [Authorize]
    [HttpPost(Name = "SaveInterests")]
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
}