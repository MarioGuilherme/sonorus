using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using Sonorus.Marketplace.Core.Entities;

namespace Sonorus.Marketplace.Infrastructure.Persistence.Configurations;

public class MediaConfiguration : IEntityTypeConfiguration<Media> {
    public void Configure(EntityTypeBuilder<Media> builder) {
        builder.HasKey(m => m.MediaId);

        builder.Property(m => m.Path).HasMaxLength(41);

        builder.HasOne(m => m.Product)
               .WithMany(p => p.Medias)
               .HasForeignKey(m => m.ProductId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}