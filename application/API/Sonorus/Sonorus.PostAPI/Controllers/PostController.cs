using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Sonorus.PostAPI.Core;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Exceptions;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Services.Interfaces;

namespace Sonorus.PostAPI.Controllers;

[ApiController]
[Route("api/v1/posts")]
public class PostController : APIControllerBase {
    private readonly IPostService _postService;
    private readonly ICommentService _commentService;

    public PostController(IPostService postService, ICommentService commentService) {
        this._postService = postService;
        this._commentService = commentService;
    }

    [Authorize]
    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<PostDTO>>))]
    public async Task<ActionResult<RestResponse<List<PostDTO>>>> GetAllPosts() {
        RestResponse<List<PostDTO>> response = new();
        try {
            this.HttpContext.Request.Headers.TryGetValue("ContentByPreference", out StringValues contentByPreferenceRaw);
            response.Data = await this._postService.GetAllAsync(this.CurrentUser!, contentByPreferenceRaw);
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

    [Authorize]
    [HttpPost("{postId}/comments")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created, Type = typeof(RestResponse<long>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<long>))]
    public async Task<ActionResult<RestResponse<long>>> SaveComment(long postId, [FromBody] string content) {
        RestResponse<long> response = new();
        try {
            response.Data = await this._commentService.SaveCommentAsync(this.CurrentUser!.UserId!.Value, postId, content);
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

    [Authorize]
    [HttpGet("{postId}/comments")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<CommentDTO>>))]
    public async Task<ActionResult<RestResponse<List<CommentDTO>>>> GetAllComments(long postId) {
        RestResponse<List<CommentDTO>> response = new();
        try {
            response.Data = await this._commentService.GetAllByPostIdAsync(postId, this.CurrentUser!);
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