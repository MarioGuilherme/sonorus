using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using Sonorus.Marketplace.Core.Entities;

namespace Sonorus.Marketplace.Infrastructure.Persistence.Configurations;

public class ProductConfiguration : IEntityTypeConfiguration<Product> {
    public void Configure(EntityTypeBuilder<Product> builder) {
        builder.HasKey(p => p.ProductId);

        builder.Property(p => p.Name)
               .HasMaxLength(50);

        builder.Property(p => p.Description)
               .HasMaxLength(255);

        builder.Property(p => p.Price)
               .HasColumnType("decimal(18,2)");

        builder.Property(p => p.AnnouncedAt)
               .HasDefaultValueSql("GETDATE()");

        builder.HasMany(p => p.Medias)
               .WithOne(m => m.Product)
               .HasForeignKey(m => m.ProductId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}