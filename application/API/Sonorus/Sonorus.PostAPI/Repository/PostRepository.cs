﻿using Microsoft.EntityFrameworkCore;
using Sonorus.PostAPI.Data;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Repository.Interfaces;

namespace Sonorus.PostAPI.Repository;

public class PostRepository : IPostRepository {
    private readonly PostAPIDbContext _dbContext;

    public PostRepository(PostAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<List<Post>> GetAll() => await this._dbContext.Posts.AsNoTracking().ToListAsync();

    public async Task<Post?> GetById(long idPost) => await this._dbContext.Posts.AsNoTracking().FirstOrDefaultAsync(post => post.IdPost == idPost);

    public async Task<long?> Create(Post post) {
        await this._dbContext.Posts.AddAsync(post);
        await this._dbContext.SaveChangesAsync();
        return post.IdPost == 0 ? null : post.IdPost;
    }

    public async Task Delete(long idPost) {
        Post post = await this._dbContext.Posts.FirstAsync(post => post.IdPost == idPost);
        this._dbContext.Posts.Remove(post);
        await this._dbContext.SaveChangesAsync();
    }

    public async Task Update(Post postForm) {
        Post post = await this._dbContext.Posts.FirstAsync(post => post.IdPost == postForm.IdPost);
        post.Content = postForm.Content;
        await this._dbContext.SaveChangesAsync();
    }

    public async Task<bool> PostExists(long idPost) => await this._dbContext.Posts.AnyAsync(post => post.IdPost == idPost);
}