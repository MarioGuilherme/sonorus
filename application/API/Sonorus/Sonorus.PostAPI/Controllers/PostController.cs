using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
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

    public PostController(IPostService postService) => this._postService = postService;

    [Authorize]
    [HttpGet(Name = "Posts")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<PostDTO>>))]
    public async Task<ActionResult<RestResponse<List<PostDTO>>>> GetAllPosts() {
        RestResponse<List<PostDTO>> response = new();
        try {
            response.Data = await this._postService.GetAll(this.CurrentUser!);
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
            response.Data = await this._postService.GetAllCommentsByPostAsync(this.CurrentUser!, postId);
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
    [HttpPost("{idPost}/like")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<PostDTO>>))]
    public async Task<ActionResult<RestResponse<long>>> Like(long idPost) {
        RestResponse<long> response = new();
        try {
            response.Data = await this._postService.LikeAsync(this.CurrentUser!.UserId!.Value, idPost);
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