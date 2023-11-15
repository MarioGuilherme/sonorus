using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using Microsoft.Extensions.Hosting;
using Sonorus.PostAPI.Data.Context;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Exceptions;
using Sonorus.PostAPI.Repository.Interfaces;

namespace Sonorus.PostAPI.Repository;

public class PostRepository : IPostRepository {
    private readonly PostAPIDbContext _dbContext;

    public PostRepository(PostAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<List<Post>> GetMoreEightPostsAsync(int offset, List<long> idsInterests, bool contentByPreference) {
        if (contentByPreference)
            return await this._dbContext.Posts
                .AsNoTracking()
                .Include(post => post.Medias)
                .Include(post => post.Interests)
                .Include(post => post.Likers)
                .Include(post => post.Comments)
                .Where(post => post.Interests.Any(interest => idsInterests.Contains(interest.InterestId)))
                .OrderByDescending(post => post.PostedAt)
                .Skip(offset)
                .Take(8)
                .ToListAsync();

        return await this._dbContext.Posts
            .AsNoTracking()
            .Include(post => post.Medias)
            .Include(post => post.Interests)
            .Include(post => post.Likers)
            .Include(post => post.Comments)
            .OrderByDescending(post => post.PostedAt)
            .Skip(offset)
            .Take(8)
            .ToListAsync();
    }

    public async Task<List<Post>> GetAllPostByUserId(long userId) => await this._dbContext.Posts
        .AsNoTracking()
        .Include(post => post.Medias)
        .Include(post => post.Interests)
        .Include(post => post.Likers)
        .Include(post => post.Comments)
        .OrderByDescending(post => post.PostedAt)
        .Where(post => post.UserId == userId)
        .ToListAsync();

    public async Task<long> LikeByPostIdAsync(long postId, long userId) {
        Post post = await this._dbContext.Posts
            .Include(post => post.Likers)
            .FirstAsync(post => post.PostId == postId);
        PostLiker? postLiker = post.Likers.FirstOrDefault(post => post.UserId == userId);

        if (postLiker is not null)
            this._dbContext.PostLikers.Remove(postLiker);
        else
            post.Likers.Add(new() { UserId = userId });

        await this._dbContext.SaveChangesAsync();

        return post.Likers.Count;
    }

    public async Task<List<string>> DeleteAllFromUserId(long userId) {
        List<Post> posts = await this._dbContext.Posts
            .Where(post => post.UserId == userId)
            .Include(post => post.Likers)
            .Include(post => post.Medias)
            .Include(post => post.Comments)
            .ThenInclude(comment => comment.Likers)
            .ToListAsync();

        List<string> productsMediasPath = new();

        foreach (var item in posts) {
            productsMediasPath.AddRange(item.Medias.Select(m => m.Path).ToList());
            this._dbContext.Medias.RemoveRange(item.Medias);
            foreach (var item1 in item.Comments) {
                this._dbContext.CommentLikers.RemoveRange(item1.Likers);
            }
            this._dbContext.Comments.RemoveRange(item.Comments);
            this._dbContext.PostLikers.RemoveRange(item.Likers);
        }

        this._dbContext.Posts.RemoveRange(posts);
        await this._dbContext.SaveChangesAsync();

        return productsMediasPath;
    }

    public async Task DeleteByPostIdAsync(long userId, long postId) {
        Post post = await this._dbContext.Posts
            .Include(post => post.Likers)
            .Include(post => post.Medias)
            .Include(post => post.Comments)
            .ThenInclude(comment => comment.Likers)
            .FirstAsync(post => post.PostId == postId);

        if (post.UserId != userId)
            throw new SonorusPostAPIException("Esta publicação não pertence à você", 403);

        this._dbContext.Medias.RemoveRange(post.Medias);
        this._dbContext.PostLikers.RemoveRange(post.Likers);
        foreach (Comment comment in post.Comments)
            this._dbContext.CommentLikers.RemoveRange(comment.Likers);
        this._dbContext.Comments.RemoveRange(post.Comments);
        this._dbContext.Posts.Remove(post);
        await this._dbContext.SaveChangesAsync();
    }

    public async Task CreatePostAsync(Post post, List<long> interestsIds, List<string> mediasName) {
        await this._dbContext.Posts.AddAsync(post);
        await this._dbContext.SaveChangesAsync();
        foreach (string path in mediasName) {
            post.Medias.Add(new() {
                Path = path
            });
        }
        foreach (long interestId in interestsIds) {
            post.Interests.Add(await this._dbContext.Interests.FirstAsync(interest => interest.InterestId == interestId));
        }
        await this._dbContext.SaveChangesAsync();
    }

    public async Task<List<string>> UpdatePostAsync(Post postForm, List<long> interestsIds, List<string> mediasName, List<string> mediasToKeep) {
    Post postDB = await this._dbContext.Posts
            .Include(p => p.Medias)
            .Include(p => p.Interests)
            .FirstAsync(post => post.PostId == postForm.PostId);
        List<string> mediasToRemove = postDB.Medias
            .Select(m => m.Path)
            .ToList();

        postDB.Content = postForm.Content;
        postDB.Tablature = postForm.Tablature;

        postDB.Interests.Clear();

        foreach (long interestId in interestsIds) {
            postDB.Interests.Add(await this._dbContext.Interests.FirstAsync(interest => interest.InterestId == interestId));
        }

        foreach (var media in postDB.Medias) {
            if (mediasToKeep.Contains(media.Path)) {
                mediasToRemove.Remove(media.Path);
                continue;
            }
            this._dbContext.Medias.Remove(media);
        }

        foreach (string path in mediasName) {
            postDB.Medias.Add(new() {
                Path = path
            });
        }

        await this._dbContext.SaveChangesAsync();
        return mediasToRemove;
    }

    public async Task InsertInterestId(long interestId) {
        this._dbContext.Interests.Add(new() { InterestId = interestId });
        await this._dbContext.SaveChangesAsync();
    }
}