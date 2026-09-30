using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.Chat.Application.Queries.GetAllChatsByUserId;
using Sonorus.Chat.Application.Queries.GetChatByFriendUserId;
using Sonorus.Chat.Application.ViewModels;
using Sonorus.SharedKernel;

namespace Sonorus.Chat.API.Controllers;

[ApiController]
[Route("api/v2")]
public class ChatsController(IMediator mediator) : ControllerBase {
    private readonly IMediator _mediator = mediator;

    [Authorize]
    [HttpGet("chats")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetAll() {
        GetAllChatsByUserIdQuery getAllChatsByUserIdQuery = new(User.UserId());
        IEnumerable<ChatViewModel> chats = await _mediator.Send(getAllChatsByUserIdQuery);
        return Ok(chats);
    }

    [Authorize]
    [HttpGet("friends/{friendId}/chat")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetByFriendId(long friendId) {
        GetChatByFriendUserIdQuery getChatByFriend = new(User.UserId(), friendId);
        ChatViewModel chat = await _mediator.Send(getChatByFriend);
        return Ok(chat);
    }
}