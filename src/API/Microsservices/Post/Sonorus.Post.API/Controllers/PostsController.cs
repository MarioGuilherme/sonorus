using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.Post.Application.Commands.CreateComment;
using Sonorus.Post.Application.Commands.CreatePost;
using Sonorus.Post.Application.Commands.DeleteCommentById;
using Sonorus.Post.Application.Commands.DeletePostById;
using Sonorus.Post.Application.Commands.ToggleLikeComment;
using Sonorus.Post.Application.Commands.ToggleLikePost;
using Sonorus.Post.Application.Commands.UpdateComment;
using Sonorus.Post.Application.Commands.UpdatePost;
using Sonorus.Post.Application.Queries.GetAllCommentsByPostId;
using Sonorus.Post.Application.Queries.GetPagedPosts;
using Sonorus.Post.Application.ViewModels;
using Sonorus.SharedKernel;

namespace Sonorus.Post.API.Controllers;

[Authorize]
[ApiController]
[Route("api/v2/posts")]
public class PostsController(IMediator mediator) : ControllerBase {
    private readonly IMediator _mediator = mediator;

    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetPagePosts(bool contentByPreference, int offset = 0, int limit = 10) {
        GetPagedPostsQuery getPagedPostsQuery = new(this.User.UserId(), this.HttpContext.AccessToken(), offset, limit, contentByPreference);
        IEnumerable<PostViewModel> posts = await this._mediator.Send(getPagedPostsQuery);
        return this.Ok(posts);
    }

    [HttpPost]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> CreatePost([FromForm] CreatePostInputModel inputModel) {
        CreatePostCommand createPostCommand = new(this.User.UserId(), inputModel);
        await this._mediator.Send(createPostCommand);
        return this.NoContent();
    }

    [HttpPatch("{postId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> UpdatePost(long postId, [FromForm] UpdatePostInputModel inputModel) {
        UpdatePostCommand updatePostCommand = new(this.User.UserId(), postId, inputModel);
        await this._mediator.Send(updatePostCommand);
        return this.NoContent();
    }

    [HttpDelete("{postId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> DeletePostById(long postId) {
        DeletePostByIdCommand deletePostByIdCommand = new(this.User.UserId(), postId);
        await this._mediator.Send(deletePostByIdCommand);
        return this.NoContent();
    }

    [HttpPatch("{postId}/likers")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> LikePost(long postId) {
        ToggleLikePostCommand likePostCommand = new(this.User.UserId(), postId);
        long totalLikes = await this._mediator.Send(likePostCommand);
        return this.Ok(totalLikes);
    }

    [HttpGet("{postId}/comments")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetAllCommentsByPostId(long postId) {
        GetAllCommentsByPostIdQuery getAllCommentsByPostIdQuery = new(this.User.UserId(), postId);
        IEnumerable<CommentViewModel> comments = await this._mediator.Send(getAllCommentsByPostIdQuery);
        return this.Ok(comments);
    }

    [HttpPost("{postId}/comments")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> CreateComment(long postId, CreateCommentInputModel inputModel) {
        CreateCommentCommand createCommentCommand = new(this.User.UserId(), postId, inputModel);
        CommentViewModel comment = await this._mediator.Send(createCommentCommand);
        return this.Created(string.Empty, comment);
    }

    [HttpPatch("{postId}/comments/{commentId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> UpdateCommentById(long postId, long commentId, UpdateCommentInputModel inputModel) {
        UpdateCommentCommand updateCommentCommand = new(this.User.UserId(), postId, commentId, inputModel);
        await this._mediator.Send(updateCommentCommand);
        return this.NoContent();
    }

    [HttpDelete("{postId}/comments/{commentId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> DeleteCommentById(long postId, long commentId) {
        DeleteCommentByIdCommand deleteCommentByIdCommand = new(this.User.UserId(), postId, commentId);
        await this._mediator.Send(deleteCommentByIdCommand);
        return this.NoContent();
    }

    [HttpPatch("{postId}/comments/{commentId}/likers")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> LikeComment(long postId, long commentId) {
        ToggleLikeCommentCommand likeCommentCommand = new(this.User.UserId(), postId, commentId);
        long totalLikes = await this._mediator.Send(likeCommentCommand);
        return this.Ok(totalLikes);
    }
}