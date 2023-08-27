using Microsoft.EntityFrameworkCore;
using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Data;

public class PostAPIDbContext : DbContext {
    public PostAPIDbContext(DbContextOptions options) : base(options) { }

    public DbSet<Post> Posts { get; set; }
    public DbSet<Comment> Comments { get; set; }
}