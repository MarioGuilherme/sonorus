using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sonorus.Post.Core.Entities;

namespace Sonorus.Post.Infrastructure.Persistence.Configurations;

public class CommentConfiguration : IEntityTypeConfiguration<Comment> {
    public void Configure(EntityTypeBuilder<Comment> builder) {
        builder.HasKey(c => c.CommentId);

        builder.Property(c => c.Content).HasMaxLength(100);
        builder.Property(b => b.CommentedAt).HasDefaultValueSql("GETDATE()");

        builder
            .HasMany(c => c.CommentLikers)
            .WithOne()
            .HasForeignKey(cl => cl.CommentId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}