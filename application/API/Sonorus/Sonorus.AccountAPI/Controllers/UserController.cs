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
    [HttpPost("picture")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<string>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<string>))]
    public async Task<ActionResult> SavePicture(IFormFile picture) {
        RestResponse<string> response = new();
        try {
            response.Data = await this._userService.SavePictureByUserIdAsync((long) this.CurrentUser!.UserId!, picture);
            return this.Created(string.Empty, response);
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
    [HttpPut]
    [Produces("application/json")]
    public async Task<ActionResult> UpdateUser(UserRegisterDTO user) {
        RestResponse<string> response = new();
        try {
            await this._userService.UpdateUser((long)this.CurrentUser!.UserId!, user);
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
    [HttpPut("picture")]
    [Produces("application/json")]
    public async Task<ActionResult> UpdatePicture(IFormFile newPicture) {
        RestResponse<string> response = new();
        try {
            response.Data = await this._userService.SavePictureByUserIdAsync((long)this.CurrentUser!.UserId!, newPicture);
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

    [Authorize]
    [HttpDelete("interests/{interestId}")]
    [Produces("application/json")]
    public async Task<ActionResult> RemoveInterest(long interestId) {
        RestResponse<string> response = new();
        try {
            await this._userService.RemoveInterest((long)this.CurrentUser!.UserId!, interestId);
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
    [HttpPatch("interests/{interestId}")]
    [Produces("application/json")]
    public async Task<ActionResult> AddInterest(long interestId) {
        RestResponse<string> response = new();
        try {
            await this._userService.AddInterest((long)this.CurrentUser!.UserId!, interestId);
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
    [HttpDelete]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<object>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult> DeleteMyUser() {
        RestResponse<object> response = new();
        try {
            this.HttpContext.Request.Headers.TryGetValue("Authorization", out var authRaw);
            await this._userService.DeleteMyAccount((long)this.CurrentUser!.UserId!, authRaw.ToString());
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

    [HttpGet("{userId}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(RestResponse<CompleteUserDTO>))]
    [ProducesResponseType(StatusCodes.Status404NotFound, Type = typeof(RestResponse<CompleteUserDTO>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<CompleteUserDTO>))]
    public async Task<ActionResult> GetCompleteUserById(long userId) {
        RestResponse<CompleteUserDTO> response = new();
        try {
            response.Data = await this._userService.GetCompleteUserByIdAsync(userId);
            return this.Ok(response);
        } catch (SonorusAccountAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [HttpPatch]
    [Authorize]
    public async Task<ActionResult> UpdatePassword([FromBody] string newPassword) {
        RestResponse<CompleteUserDTO> response = new();
        try {
            await this._userService.UpdatePassword((long)this.CurrentUser!.UserId!, newPassword);
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

    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult> GetRangeOfUsersById([FromHeader] List<long> userIds) {
        RestResponse<object> response = new();
        try {
            response.Data = await this._userService.GetUsersByUserIdsAsync(userIds);
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