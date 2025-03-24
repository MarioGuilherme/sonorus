using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sonorus.Post.Core.Entities;

namespace Sonorus.Post.Infrastructure.Persistence.Configurations;

public class PostLikerConfiguration : IEntityTypeConfiguration<PostLiker> {
    public void Configure(EntityTypeBuilder<PostLiker> builder) {
        builder.HasKey(pl => new { pl.PostId, pl.UserId });

        builder
            .HasOne(pl => pl.Post)
            .WithMany(c => c.PostLikers)
            .HasForeignKey(pl => pl.PostId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}