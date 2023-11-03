using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.PostAPI.Core;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Exceptions;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Services.Interfaces;

namespace Sonorus.PostAPI.Controllers;

[ApiController]
[Route("api/v1/commentLikers")]
public class CommentLikerController : APIControllerBase {
    private readonly ICommentService _commentService;

    public CommentLikerController(ICommentService commentService) => this._commentService = commentService;

    [Authorize]
    [HttpPost("{commentId}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<PostDTO>>))]
    public async Task<ActionResult<RestResponse<long>>> Like(long commentId) {
        RestResponse<long> response = new();
        try {
            response.Data = await this._commentService.LikeByCommentIdAsync(commentId, this.CurrentUser!.UserId!.Value);
            return this.Ok(response);
        } catch (SonorusPostAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }
}