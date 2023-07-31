using Microsoft.AspNetCore.Mvc;
using Sonorus.PostAPI.Configuration;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Service.Interfaces;

namespace Sonorus.PostAPI.Controllers;

[ApiController]
[Route("api/v1/comments")]
public class CommentController : ControllerBase {
    private readonly ICommentService _commentService;

    public CommentController(ICommentService commentService) => this._commentService = commentService;

    [HttpGet]
    public async Task<ActionResult<RestResponse<List<CommentDTO>>>> GetAll() {
        RestResponse<List<CommentDTO>> response = new();

        try {
            response.Data = await this._commentService.GetAll();
            return this.Ok(response);
        } catch (Exception exception) {
            response.Message = exception.Message;
            return this.StatusCode(500, response);
        }
    }
}