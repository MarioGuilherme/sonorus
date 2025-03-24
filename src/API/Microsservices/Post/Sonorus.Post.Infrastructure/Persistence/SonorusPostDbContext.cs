using Microsoft.EntityFrameworkCore;
using Sonorus.Post.Core.Entities;
using System.Reflection;

namespace Sonorus.Post.Infrastructure.Persistence;

public class SonorusPostDbContext(DbContextOptions<SonorusPostDbContext> options) : DbContext(options) {
    public DbSet<Core.Entities.Post> Posts { get; set; }
    public DbSet<Media> Medias { get; set; }
    public DbSet<Comment> Comments { get; set; }
    public DbSet<PostLiker> PostsLikers { get; set; }
    public DbSet<CommentLiker> CommentsLikers { get; set; }
    public DbSet<PostInterest> PostsInterests { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder) => modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) => optionsBuilder.EnableSensitiveDataLogging();
}