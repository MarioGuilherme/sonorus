using Microsoft.EntityFrameworkCore;
using Sonorus.PostAPI.Data.Entities;
using System.Reflection.Emit;
using System.Reflection.Metadata;

namespace Sonorus.PostAPI.Data.Context;

public class PostAPIDbContext : DbContext {
    public PostAPIDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder) {
        builder.Entity<Post>()
            .HasMany(p => p.Comments)
            .WithOne(c => c.Post)
            .HasForeignKey("PostId");

        builder.Entity<Post>()
            .HasMany(p => p.Medias)
            .WithOne(c => c.Post)
        .HasForeignKey("PostId");

        builder.Entity<Post>()
            .Property(b => b.PostedAt)
            .HasDefaultValue(DateTime.Now);

        builder.Entity<Comment>()
            .Property(b => b.CommentedAt)
            .HasDefaultValue(DateTime.Now);
    }

    public DbSet<Post> Posts { get; set; }
    public DbSet<PostLiker> PostLikers { get; set; }
    public DbSet<CommentLiker> CommentLikers { get; set; }
    public DbSet<Media> Medias { get; set; }
    public DbSet<Interest> Interests { get; set; }
    public DbSet<Comment> Comments { get; set; }
}