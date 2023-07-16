using Microsoft.EntityFrameworkCore;

namespace Sonorus.PostAPI.Models.Context;

public class ApplicationDbContext : DbContext {
    public ApplicationDbContext(DbContextOptions options) : base(options) {}

    public DbSet<Post> Posts { get; set; }
}