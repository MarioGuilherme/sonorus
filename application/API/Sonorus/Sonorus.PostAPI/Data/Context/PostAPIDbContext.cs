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
            .HasDefaultValueSql("GETDATE()");

        builder.Entity<Comment>()
            .Property(b => b.CommentedAt)
            .HasDefaultValueSql("GETDATE()");

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
            new() { InterestId = 5 },
            new() { InterestId = 6 },
            new() { InterestId = 7 },
            new() { InterestId = 8 },
            new() { InterestId = 9 },
            new() { InterestId = 10 },
            new() { InterestId = 11 },
            new() { InterestId = 12 },
            new() { InterestId = 13 },
            new() { InterestId = 14 },
            new() { InterestId = 15 },
            new() { InterestId = 16 },
            new() { InterestId = 17 },
            new() { InterestId = 18 },
            new() { InterestId = 19 },
            new() { InterestId = 20 },
            new() { InterestId = 21 },
            new() { InterestId = 22 },
            new() { InterestId = 23 },
            new() { InterestId = 24 },
            new() { InterestId = 25 },
            new() { InterestId = 26 },
            new() { InterestId = 27 },
            new() { InterestId = 28 },
            new() { InterestId = 29 },
            new() { InterestId = 30 },
            new() { InterestId = 31 },
            new() { InterestId = 32 },
            new() { InterestId = 33 },
            new() { InterestId = 34 },
            new() { InterestId = 35 },
            new() { InterestId = 36 },
            new() { InterestId = 37 },
            new() { InterestId = 38 },
            new() { InterestId = 39 },
            new() { InterestId = 40 },
            new() { InterestId = 41 },
            new() { InterestId = 42 },
            new() { InterestId = 43 },
            new() { InterestId = 44 },
            new() { InterestId = 45 },
            new() { InterestId = 46 },
            new() { InterestId = 47 },
            new() { InterestId = 48 },
            new() { InterestId = 49 }
        });
    }

    public DbSet<Post> Posts { get; set; }
    public DbSet<PostLiker> PostLikers { get; set; }
    public DbSet<CommentLiker> CommentLikers { get; set; }
    public DbSet<Media> Medias { get; set; }
    public DbSet<Interest> Interests { get; set; }
    public DbSet<Comment> Comments { get; set; }
}