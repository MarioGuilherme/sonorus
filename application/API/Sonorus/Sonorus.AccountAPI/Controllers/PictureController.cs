using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.AccountAPI.Configuration;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Services.Interfaces;

namespace Sonorus.AccountAPI.Controllers;

[ApiController]
[Route("api/v1/picture")]
public class PictureController : APIControllerBase {
    private readonly IUserService _userService;

    public PictureController(IUserService userService) => this._userService = userService;

    [Authorize]
    [HttpPost(Name = "SavePicture")]
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