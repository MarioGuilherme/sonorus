﻿using Microsoft.EntityFrameworkCore;
using Sonorus.PostAPI.Data;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Repository.Interfaces;

namespace Sonorus.PostAPI.Repository;

public class CommentRepository : ICommentRepository {
    private readonly PostAPIDbContext _dbContext;

    public CommentRepository(PostAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<List<Comment>> GetAll() => await this._dbContext.Comments.AsNoTracking().ToListAsync();
}