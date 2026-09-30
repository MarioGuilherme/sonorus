using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Repositories;

namespace Sonorus.Post.Infrastructure.Persistence.Repositories;

public class PostRepository(SonorusPostDbContext context) : IPostRepository {
    private readonly SonorusPostDbContext _dbContext = context;

    public async Task CreatePostAsync(Core.Entities.Post post) {
        await _dbContext.Posts.AddAsync(post);
    }

    public void Delete(Core.Entities.Post post) {
        foreach (Comment comment in post.Comments) _dbContext.CommentsLikers.RemoveRange(comment.CommentLikers);

        _dbContext.Medias.RemoveRange(post.Medias);
        _dbContext.PostsInterests.RemoveRange(post.PostInterests);
        _dbContext.PostsLikers.RemoveRange(post.PostLikers);
        _dbContext.Comments.RemoveRange(post.Comments);

        _dbContext.Posts.Remove(post);
    }

    public IEnumerable<string> DeleteAllFromUserId(long userId) {
        List<Core.Entities.Post> posts = [.. _dbContext.Posts
            .Include(post => post.Medias)
            .Include(post => post.PostInterests)
            .Include(post => post.PostLikers)
            .Include(post => post.Comments)
            .ThenInclude(comment => comment.CommentLikers)
            .Where(post => post.UserId == userId)];

        foreach (Core.Entities.Post post in posts) {
            foreach (Comment comment in post.Comments) _dbContext.CommentsLikers.RemoveRange(comment.CommentLikers);
            _dbContext.Medias.RemoveRange(post.Medias);
            _dbContext.PostsInterests.RemoveRange(post.PostInterests);
            _dbContext.PostsLikers.RemoveRange(post.PostLikers);
            _dbContext.Comments.RemoveRange(post.Comments);
        }

        _dbContext.Posts.RemoveRange(posts);

        return posts.SelectMany(p => p.Medias.Select(m => m.Path));
    }

    public void DeleteCommentFromPost(Core.Entities.Post post, Comment comment) {
        _dbContext.CommentsLikers.RemoveRange(comment.CommentLikers);
        _dbContext.Comments.Remove(comment);
    }

    public async Task<List<Comment>?> GetAllCommentsByPostIdAsync(long postId) => [.. (await _dbContext.Posts
        .AsNoTracking()
        .Include(post => post.Comments)
        .ThenInclude(comment => comment.CommentLikers)
        .FirstOrDefaultAsync(p => p.PostId == postId)
    )?.Comments];

    public Task<Core.Entities.Post?> GetByIdWithFullDataTrackingAsync(long postId) => _dbContext.Posts
        .Include(post => post.Medias)
        .Include(post => post.PostLikers)
        .Include(post => post.PostInterests)
        .Include(post => post.Comments)
        .ThenInclude(comment => comment.CommentLikers)
        .FirstOrDefaultAsync(post => post.PostId == postId);

    public Task<Core.Entities.Post?> GetByIdWithPostLikersTrackingAsync(long postId) => _dbContext.Posts
        .Include(post => post.PostLikers)
        .FirstOrDefaultAsync(post => post.PostId == postId);

    public async Task<List<Core.Entities.Post>> GetPagedPostsAsync(int offset, int limit, IEnumerable<long>? interestsIds = default) {
        IIncludableQueryable<Core.Entities.Post, ICollection<Comment>> query = _dbContext.Posts
            .AsNoTracking()
            .Include(post => post.Medias)
            .Include(post => post.PostInterests)
            .Include(post => post.PostLikers)
            .Include(post => post.Comments);

        return interestsIds is not null
            ? await query
                .Where(post => post.PostInterests.Any(interest => interestsIds.Contains(interest.InterestId)))
                .OrderByDescending(post => post.PostedAt)
                .Skip(offset)
                .Take(limit)
                .ToListAsync()
            : await query
                .OrderByDescending(post => post.PostedAt)
                .Skip(offset)
                .Take(8)
                .ToListAsync();
    }

    public async Task<long> GetTotalLikersOfCommentIdAsync(long commentId) => (await _dbContext.Comments
        .AsNoTracking()
        .Include(comment => comment.CommentLikers)
        .FirstOrDefaultAsync(comment => comment.CommentId == commentId)
    )?.CommentLikers.Count ?? 0;

    public void UpdatePost(Core.Entities.Post postForm, IEnumerable<Media> mediasToRemove) {
        _dbContext.Medias.RemoveRange(mediasToRemove);
        foreach (PostInterest postInterest in postForm.PostInterests)
            _dbContext.Attach(postInterest);
    }
}