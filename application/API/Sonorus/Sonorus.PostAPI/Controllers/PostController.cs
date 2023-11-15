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
    public async Task<ActionResult<RestResponse<List<PostDTO>>>> GetMoreEightPosts([FromHeader] int offset, [FromHeader] bool contentByPreference) {
        RestResponse<List<PostDTO>> response = new();
        try {
            response.Data = await this._postService.GetMoreEightPostsAsync(this.CurrentUser!, offset, contentByPreference);
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
    [HttpPost]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult<RestResponse<object>>> CreatePost([FromForm] NewPostDTO post, IEnumerable<IFormFile> medias) {
        RestResponse<object> response = new();
        try {
            await this._postService.CreatePostAsync((long)this.CurrentUser!.UserId!, post, medias.ToList());
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
    [HttpPatch]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult<RestResponse<object>>> UpdatePost([FromForm] NewPostDTO post, IEnumerable<IFormFile> medias) {
        RestResponse<object> response = new();
        try {
            await this._postService.UpdatePostAsync((long)this.CurrentUser!.UserId!, post, medias.ToList());
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
    [HttpDelete]
    [Produces("application/json")]
    public async Task<ActionResult<RestResponse<PostDTO>>> DeleteAllFromUser() {
        RestResponse<PostDTO> response = new();
        try {
            await this._postService.DeleteAllFromUser((long)this.CurrentUser!.UserId!);
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

    [Authorize]
    [HttpDelete("{postId}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult<RestResponse<PostDTO>>> DeletePost(long postId) {
        RestResponse<object> response = new();
        try {
            await this._postService.DeleteByPostIdAsync((long)this.CurrentUser!.UserId!, postId);
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