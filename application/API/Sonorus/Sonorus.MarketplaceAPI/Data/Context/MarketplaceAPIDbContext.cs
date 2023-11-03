using Microsoft.EntityFrameworkCore;
using Sonorus.MarketplaceAPI.Data.Entities;

namespace Sonorus.MarketplaceAPI.Data.Context;

public class MarketplaceAPIDbContext : DbContext {
    public MarketplaceAPIDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder) {
        builder.Entity<Product>()
            .HasMany(p => p.Medias)
            .WithOne(m => m.Product)
        .HasForeignKey("ProductId");

        builder.Entity<Product>()
            .Property(p => p.Price)
            .HasColumnType("decimal(18,2)");

        builder.Entity<Product>()
            .Property(p => p.AnnouncedAt)
            .HasDefaultValue(DateTime.Now);
    }

    public DbSet<Product> Products { get; set; }
}