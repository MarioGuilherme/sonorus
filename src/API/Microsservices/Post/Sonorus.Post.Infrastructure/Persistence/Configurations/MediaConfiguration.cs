using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using Sonorus.Post.Core.Entities;

namespace Sonorus.Post.Infrastructure.Persistence.Configurations;

public class MediaConfiguration : IEntityTypeConfiguration<Media> {
    public void Configure(EntityTypeBuilder<Media> builder) {
        builder.HasKey(m => m.MediaId);

        builder.Property(m => m.Path).HasMaxLength(41);
    }
}