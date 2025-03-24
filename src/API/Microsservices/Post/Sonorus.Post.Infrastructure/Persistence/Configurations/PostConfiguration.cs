using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using Sonorus.Post.Core.Entities;

namespace Sonorus.Post.Infrastructure.Persistence.Configurations;

public class PostConfiguration : IEntityTypeConfiguration<Core.Entities.Post> {
    public void Configure(EntityTypeBuilder<Core.Entities.Post> builder) {
        builder.HasKey(p => p.PostId);

        builder.Property(p => p.Content).HasMaxLength(300);

        builder
            .Property(p => p.PostedAt)
            .HasDefaultValueSql("GETDATE()");

        builder
            .HasMany(p => p.Medias)
            .WithOne()
            .HasForeignKey(nameof(Media.PostId))
            .OnDelete(DeleteBehavior.Restrict);

        builder
            .HasMany(p => p.Comments)
            .WithOne()
            .HasForeignKey(nameof(Comment.PostId))
            .OnDelete(DeleteBehavior.Restrict);

        builder
            .HasMany(p => p.PostLikers)
            .WithOne(pl => pl.Post)
            .HasForeignKey(pi => pi.PostId)
            .OnDelete(DeleteBehavior.Restrict);

        builder
            .HasMany(p => p.PostInterests)
            .WithOne(pi => pi.Post)
            .HasForeignKey(pi => pi.PostId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}