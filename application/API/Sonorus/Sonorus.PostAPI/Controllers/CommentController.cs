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
    private readonly ICommentService _commentService;

    public CommentController(IPostService postService, ICommentService commentService) {
        this._postService = postService;
        this._commentService = commentService;
    }

    [Authorize]
    [HttpPost]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created, Type = typeof(RestResponse<CommentDTO>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<CommentDTO>))]
    public async Task<ActionResult<RestResponse<CommentDTO>>> SaveComment(NewCommentDTO newComment) {
        RestResponse<CommentDTO> response = new();
        try {
            response.Data = await this._commentService.SaveCommentAsync(this.CurrentUser!.UserId!.Value, newComment);
            return this.Created(string.Empty, response);
        } catch (SonorusPostAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpPatch("{commentId}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult<RestResponse<PostDTO>>> UpdateComment(long commentId, [FromBody] string newContent) {
        RestResponse<object> response = new();
        try {
            await this._commentService.UpdateCommentById(this.CurrentUser!.UserId!.Value, commentId, newContent);
            return this.NoContent();
        } catch (SonorusPostAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpDelete("{commentId}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult<RestResponse<PostDTO>>> DeleteComment(long commentId) {
        RestResponse<object> response = new();
        try {
            await this._commentService.DeleteCommentById(this.CurrentUser!.UserId!.Value, commentId);
            return this.NoContent();
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