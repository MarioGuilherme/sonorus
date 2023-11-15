using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Sonorus.ChatAPI.Core;
using Sonorus.ChatAPI.Data;
using Sonorus.ChatAPI.DTO;
using Sonorus.ChatAPI.Exceptions;
using Sonorus.ChatAPI.Models;
using Sonorus.ChatAPI.Services.Interfaces;

namespace Sonorus.ChatAPI.Controllers;

[ApiController]
[Route("api/v1/users")]
public class UserController : APIControllerBase {
    private readonly IChatService _chatService;

    public UserController(IChatService chatService) => this._chatService = chatService;

    [Authorize]
    [HttpGet("{friendId}/messages")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<ChatDTO>))]
    public async Task<ActionResult<RestResponse<ChatDTO>>> GetChatWithFriend(long friendId) {
        RestResponse<ChatDTO> response = new();
        try {
            response.Data = await this._chatService.GetChatWithFriendAsync(friendId, (long) this.CurrentUser!.UserId!);
            return this.Ok(response);
        } catch (SonorusChatAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }
}