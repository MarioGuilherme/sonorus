using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.Account.Application.Commands.AssociateCollectionOfInterests;
using Sonorus.Account.Application.Commands.AssociateInterest;
using Sonorus.Account.Application.Commands.DeleteUserById;
using Sonorus.Account.Application.Commands.DisassociateInterest;
using Sonorus.Account.Application.Commands.UpdatePassword;
using Sonorus.Account.Application.Commands.UpdatePicture;
using Sonorus.Account.Application.Commands.UpdateUser;
using Sonorus.Account.Application.Queries.GetAllInterestsFromUser;
using Sonorus.Account.Application.Queries.GetAuthenticatedUser;
using Sonorus.Account.Application.Queries.GetUsersById;
using Sonorus.Account.Application.ViewModels;
using Sonorus.SharedKernel;

namespace Sonorus.Account.API.Controllers;

[Authorize]
[ApiController]
[Route("api/v2/users")]
public class UsersController(IMediator mediator) : ControllerBase
{
    private readonly IMediator _mediator = mediator;

    [HttpGet("me")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAuthenticatedUser()
    {
        GetAuthenticatedUserQuery getAuthenticatedUserQuery = new(User.UserId());
        AuthenticatedUserViewModel authenticatedUser = await _mediator.Send(getAuthenticatedUserQuery);
        return Ok(authenticatedUser);
    }

    [HttpPatch("me/picture")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> UpdatePicture(IFormFile file)
    {
        UpdatePictureCommand updatePictureCommand = new(User.UserId(), file);
        string uri = await _mediator.Send(updatePictureCommand);
        return Created(uri, default);
    }

    [HttpPatch("me")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> Update(UpdateUserInputModel inputModel)
    {
        UpdateUserCommand updateUserCommand = new(User.UserId(), inputModel);
        await _mediator.Send(updateUserCommand);
        return NoContent();
    }

    [HttpDelete("me/interests/{interestId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> DisassociateInterest(long interestId)
    {
        DisassociateInterestCommand disassociateInterestCommand = new(User.UserId(), interestId);
        await _mediator.Send(disassociateInterestCommand);
        return NoContent();
    }

    [HttpPost("me/interests/{interestId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> AssociateInterest(long interestId)
    {
        AssociateInterestCommand associateInterestCommand = new(User.UserId(), interestId);
        await _mediator.Send(associateInterestCommand);
        return NoContent();
    }

    [HttpPost("me/interests")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> AssociateCollectionOfInterests(AssociateCollectionOfInterestsInputModel inputModel)
    {
        AssociateCollectionOfInterestsCommand associateInterests = new(User.UserId(), inputModel);
        await _mediator.Send(associateInterests);
        return NoContent();
    }

    [HttpDelete("me")]
    [ProducesResponseType(StatusCodes.Status202Accepted)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> DeleteMyAccount()
    {
        DeleteUserByIdCommand deleteUserByIdCommand = new(User.UserId());
        await _mediator.Send(deleteUserByIdCommand);
        return Accepted();
    }

    [HttpGet("me/interests")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetMyInterests()
    {
        GetAllInterestsFromUserQuery getAllInterestsFromUserQuery = new(User.UserId());
        IEnumerable<InterestViewModel> interests = await _mediator.Send(getAllInterestsFromUserQuery);
        return Ok(interests);
    }

    [HttpPatch("me/password")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> UpdatePassword(UpdatePasswordInputModel inputModel)
    {
        UpdatePasswordCommand updatePasswordCommand = new(User.UserId(), inputModel.Password);
        await _mediator.Send(updatePasswordCommand);
        return NoContent();
    }

    [AllowAnonymous]
    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetByIds([FromQuery(Name = "id")] IEnumerable<long> userIds)
    {
        GetUsersByIdQuery getUsersByIdQuery = new(userIds);
        IEnumerable<UserViewModel> users = await _mediator.Send(getUsersByIdQuery);
        return Ok(users);
    }
}