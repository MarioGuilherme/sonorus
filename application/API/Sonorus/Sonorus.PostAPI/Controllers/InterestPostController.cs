using Microsoft.AspNetCore.Mvc;
using Sonorus.PostAPI.Core;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Exceptions;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Services.Interfaces;

namespace Sonorus.PostAPI.Controllers;

[ApiController]
[Route("api/v1/interestsPost")]
public class InterestPostController : APIControllerBase {
    private readonly IPostService _postService;

    public InterestPostController(IPostService postService) {
        this._postService = postService;
    }

    [HttpPost]
    public async Task<ActionResult<RestResponse<object>>> InsertInterestId([FromBody] long postId) {
        RestResponse<CommentDTO> response = new();
        try {
            await this._postService.InsertInterestId(postId);
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