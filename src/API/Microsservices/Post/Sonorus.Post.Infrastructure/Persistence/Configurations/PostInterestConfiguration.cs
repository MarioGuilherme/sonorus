using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sonorus.Post.Core.Entities;

namespace Sonorus.Post.Infrastructure.Persistence.Configurations;

public class PostInterestConfiguration : IEntityTypeConfiguration<PostInterest> {
    public void Configure(EntityTypeBuilder<PostInterest> builder) {
        builder.HasKey(pi => new { pi.PostId, pi.InterestId });

        builder
            .HasOne(pi => pi.Post)
            .WithMany(p => p.PostInterests)
            .HasForeignKey(pi => pi.PostId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}