using Microsoft.EntityFrameworkCore;
using Sonorus.BusinessAPI.Data.Entities;

namespace Sonorus.BusinessAPI.Data.Context;

public class BusinessAPIDbContext : DbContext {
    public BusinessAPIDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder) {
        builder.Entity<Opportunity>()
            .Property(b => b.AnnouncedAt)
            .HasDefaultValueSql("GETDATE()");
    }

    public DbSet<Opportunity> Opportunities { get; set; }
}