using Microsoft.EntityFrameworkCore;
using Sonorus.Marketplace.Core.Entities;
using System.Reflection;

namespace Sonorus.Marketplace.Infrastructure.Persistence;

public class SonorusMarketplaceDbContext(DbContextOptions<SonorusMarketplaceDbContext> options) : DbContext(options) {
    public DbSet<Product> Products { get; set; }
    public DbSet<Media> Medias { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder) => modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) => optionsBuilder.EnableSensitiveDataLogging();
}