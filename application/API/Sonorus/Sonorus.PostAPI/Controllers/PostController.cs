using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.PostAPI.Configuration;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Exceptions;
using Sonorus.PostAPI.Service.Interfaces;

namespace Sonorus.PostAPI.Controllers;

[ApiController]
[Route("api/v1/posts")]
public class PostController : ControllerBase {
    private readonly IPostService _postService;

    public PostController(IPostService postService) => this._postService = postService;

    [HttpGet(Name = "GetPosts")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<ActionResult<RestResponse<List<PostDTO>>>> GetAll() {
        RestResponse<List<PostDTO>> response = new();

        try {
            response.Data = await this._postService.GetAll();
            return this.Ok(response);
        } catch (PostAPIException exception) {
            response.Message = exception.Message;
            return this.StatusCode(exception.StatusCode, response);
        }
    }


    [HttpGet("{idPost}", Name = "GetPost")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<RestResponse<PostDTO?>>> GetPostById(long idPost) {
        RestResponse<PostDTO?> response = new();
        try {
            response.Data = await this._postService.GetPostById(idPost);
            return this.Ok(response);
        } catch (PostAPIException exception) {
            response.Message = exception.Message;
            return this.StatusCode(exception.StatusCode, response);
        }
    }

    [Authorize]
    [HttpPost(Name = "CreatePost")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    public async Task<ActionResult<RestResponse<string>>> Create(PostDTO post) {
        RestResponse<string> response = new();
        try {
            long idPost = await this._postService.Create(post);
            return this.CreatedAtRoute("GetPosts", new { idPost });
        } catch (PostAPIException exception) {
            response.Message = exception.Message;
            return this.StatusCode(exception.StatusCode, response);
        }
    }

    [Authorize]
    [HttpPut(Name = "UpdatePost")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> Update(PostDTO post) {
        RestResponse<object> response = new();
        try {
            await this._postService.Update(post);
            return this.NoContent();
        } catch (PostAPIException exception) {
            response.Message = exception.Message;
            return this.StatusCode(exception.StatusCode, response);
        }
    }

    [Authorize]
    [HttpDelete("{idPost}", Name = "DeletePost")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> Delete([FromRoute] long idPost) {
        try {
            await this._postService.Delete(idPost);
            return this.NoContent();
        } catch (PostAPIException exception) {
            return this.StatusCode(exception.StatusCode, new RestResponse<object>() {
                Message = exception.Message
            });
        }
    }
}