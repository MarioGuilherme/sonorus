using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sonorus.Post.Core.Entities;

namespace Sonorus.Post.Infrastructure.Persistence.Configurations;

public class CommentLikerConfiguration : IEntityTypeConfiguration<CommentLiker> {
    public void Configure(EntityTypeBuilder<CommentLiker> builder) {
        builder.HasKey(cl => new { cl.CommentId, cl.UserId });

        builder
            .HasOne(cl => cl.Comment)
            .WithMany(c => c.CommentLikers)
            .HasForeignKey(cl => cl.CommentId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}