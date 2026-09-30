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
public class PostsController(IMediator mediator) : ControllerBase
{
    private readonly IMediator _mediator = mediator;

    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetPagePosts(bool contentByPreference, int offset = 0, int limit = 10)
    {
        GetPagedPostsQuery getPagedPostsQuery = new(User.UserId(), HttpContext.AccessToken(), offset, limit, contentByPreference);
        IEnumerable<PostViewModel> posts = await _mediator.Send(getPagedPostsQuery);
        return Ok(posts);
    }

    [HttpPost]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> CreatePost([FromForm] CreatePostInputModel inputModel)
    {
        CreatePostCommand createPostCommand = new(User.UserId(), inputModel);
        await _mediator.Send(createPostCommand);
        return NoContent();
    }

    [HttpPatch("{postId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> UpdatePost(long postId, [FromForm] UpdatePostInputModel inputModel)
    {
        UpdatePostCommand updatePostCommand = new(User.UserId(), postId, inputModel);
        await _mediator.Send(updatePostCommand);
        return NoContent();
    }

    [HttpDelete("{postId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> DeletePostById(long postId)
    {
        DeletePostByIdCommand deletePostByIdCommand = new(User.UserId(), postId);
        await _mediator.Send(deletePostByIdCommand);
        return NoContent();
    }

    [HttpPatch("{postId}/likers")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> LikePost(long postId)
    {
        ToggleLikePostCommand likePostCommand = new(User.UserId(), postId);
        long totalLikes = await _mediator.Send(likePostCommand);
        return Ok(totalLikes);
    }

    [HttpGet("{postId}/comments")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetAllCommentsByPostId(long postId)
    {
        GetAllCommentsByPostIdQuery getAllCommentsByPostIdQuery = new(User.UserId(), postId);
        IEnumerable<CommentViewModel> comments = await _mediator.Send(getAllCommentsByPostIdQuery);
        return Ok(comments);
    }

    [HttpPost("{postId}/comments")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> CreateComment(long postId, CreateCommentInputModel inputModel)
    {
        CreateCommentCommand createCommentCommand = new(User.UserId(), postId, inputModel);
        CommentViewModel comment = await _mediator.Send(createCommentCommand);
        return Created(string.Empty, comment);
    }

    [HttpPatch("{postId}/comments/{commentId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> UpdateCommentById(long postId, long commentId, UpdateCommentInputModel inputModel)
    {
        UpdateCommentCommand updateCommentCommand = new(User.UserId(), postId, commentId, inputModel);
        await _mediator.Send(updateCommentCommand);
        return NoContent();
    }

    [HttpDelete("{postId}/comments/{commentId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> DeleteCommentById(long postId, long commentId)
    {
        DeleteCommentByIdCommand deleteCommentByIdCommand = new(User.UserId(), postId, commentId);
        await _mediator.Send(deleteCommentByIdCommand);
        return NoContent();
    }

    [HttpPatch("{postId}/comments/{commentId}/likers")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> LikeComment(long postId, long commentId)
    {
        ToggleLikeCommentCommand likeCommentCommand = new(User.UserId(), postId, commentId);
        long totalLikes = await _mediator.Send(likeCommentCommand);
        return Ok(totalLikes);
    }
}