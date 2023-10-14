using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.PostAPI.Core;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Exceptions;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Services.Interfaces;

namespace Sonorus.PostAPI.Controllers;

[ApiController]
[Route("api/v1/comments")]
public class CommentController : APIControllerBase {
    private readonly IPostService _postService;

    public CommentController(IPostService postService) => this._postService = postService;

    [Authorize]
    [HttpPost("{commentId}/like")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<PostDTO>>))]
    public async Task<ActionResult<RestResponse<long>>> LikeComment(long commentId) {
        RestResponse<long> response = new();
        try {
            response.Data = await this._postService.LikeCommentByIdAsync(this.CurrentUser!.UserId!.Value, commentId);
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