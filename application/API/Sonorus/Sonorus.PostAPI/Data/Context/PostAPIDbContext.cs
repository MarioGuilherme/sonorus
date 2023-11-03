using Microsoft.EntityFrameworkCore;
using Sonorus.PostAPI.Data.Entities;

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

        builder.Entity<Post>()
        .HasMany(p => p.Interests)
        .WithMany(i => i.Posts)
        .UsingEntity(
            "InterestsPosts",
            l => l.HasOne(typeof(Interest)).WithMany().HasForeignKey("InterestId").HasPrincipalKey(nameof(Interest.InterestId)),
            r => r.HasOne(typeof(Post)).WithMany().HasForeignKey("PostId").HasPrincipalKey(nameof(Post.PostId)),
            j => j.HasKey("PostId", "InterestId")
        );

        builder.Entity<Interest>().HasData(new Interest[] {
            new() { InterestId = 1 },
            new() { InterestId = 2 },
            new() { InterestId = 3 },
            new() { InterestId = 4 },
            new() { InterestId = 5 }
        });
    }

    public DbSet<Post> Posts { get; set; }
    public DbSet<PostLiker> PostLikers { get; set; }
    public DbSet<CommentLiker> CommentLikers { get; set; }
    public DbSet<Media> Medias { get; set; }
    public DbSet<Interest> Interests { get; set; }
    public DbSet<Comment> Comments { get; set; }
}