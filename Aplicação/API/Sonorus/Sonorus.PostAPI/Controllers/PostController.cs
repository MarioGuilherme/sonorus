using Microsoft.AspNetCore.Mvc;
using Sonorus.PostAPI.Configuration;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Service.Interfaces;

namespace Sonorus.PostAPI.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class PostController : ControllerBase {
    private readonly IPostService _postService;

    public PostController(IPostService postService) => this._postService = postService;

    [HttpGet]
    public async Task<ActionResult<List<PostDTO>>> Index() => this.Ok(await this._postService.GetAll());

    [HttpGet("{idPost}")]
    public async Task<ActionResult<PostDTO>> Index(long idPost) => this.Ok(await this._postService.GetById(idPost));

    [HttpPost]
    public async Task<ActionResult<long>> Create(PostDTO post) => this.StatusCode(201, await this._postService.Create(post));

    [HttpPut]
    public async Task<ActionResult> Update(long idPost, PostDTO post) {
        bool postExists = await this._postService.PostExists(idPost);

        if (!postExists)
            return this.NotFound();

        await this._postService.Update(idPost, post);
        return this.NoContent();
    }

    [HttpDelete("{idPost}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> Delete(long idPost) {

        try {
            bool postExists = await this._postService.PostExists(idPost);

            if (!postExists) {
                //throw new SonorusAPIException("Publicação não encontrada", 404);
                return this.NotFound(null);
            }

            await this._postService.Delete(idPost);
            return this.NoContent();
        } /*catch (SonorusAPIException error) {
            RestResponse<bool?> response = new() { Message = error.Message };
            return this.StatusCode(error.StatusCode, response);
        } */ catch (Exception error) {
            RestResponse<bool?> response = new() { Message = error.Message };
            return this.StatusCode(500, response);
        }
    }
}