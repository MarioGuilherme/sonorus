using Microsoft.EntityFrameworkCore;
using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Data;

public class SonorusDbContext : DbContext {
    public SonorusDbContext(DbContextOptions options) : base(options) { }

    public DbSet<Post> Posts { get; set; }
    public DbSet<Comment> Comments { get; set; }
}