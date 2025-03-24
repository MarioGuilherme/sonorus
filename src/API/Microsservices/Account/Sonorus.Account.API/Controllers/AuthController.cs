using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.Account.Application.Commands.RegenerateAccessToken;
using Sonorus.Account.Application.Commands.CreateUser;
using Sonorus.Account.Application.Queries.GetUserByLogin;
using Sonorus.Account.Application.ViewModels;
using Sonorus.SharedKernel;

namespace Sonorus.Account.API.Controllers;

[ApiController]
[Route("api/v2/auth")]
public class AuthController(IMediator mediator) : ControllerBase {
    private readonly IMediator _mediator = mediator;

    [AllowAnonymous]
    [HttpPost("login")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Login(GetUserByLoginQuery query) {
        TokenViewModel tokenViewModel = await this._mediator.Send(query);
        return this.Ok(tokenViewModel);
    }

    [AllowAnonymous]
    [HttpPost("register")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Create(CreateUserCommand command) {
        TokenViewModel tokenViewModel = await this._mediator.Send(command);
        return this.Ok(tokenViewModel);
    }

    [Authorize]
    [HttpPut("refreshToken")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> RefreshToken(RefreshTokenInputModel inputModel) {
        RegenerateAccessTokenCommand recreateAccessAndRefreshTokenCommand = new(this.User.UserId(), inputModel.RefreshToken);
        TokenViewModel tokenViewModel = await this._mediator.Send(recreateAccessAndRefreshTokenCommand);
        return this.Ok(tokenViewModel);
    }
}