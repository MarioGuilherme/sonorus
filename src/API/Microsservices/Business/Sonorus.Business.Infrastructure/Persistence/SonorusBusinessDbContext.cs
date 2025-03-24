using Microsoft.EntityFrameworkCore;
using Sonorus.Business.Core.Entities;
using System.Reflection;

namespace Sonorus.Business.Infrastructure.Persistence;

public class SonorusBusinessDbContext(DbContextOptions<SonorusBusinessDbContext> options) : DbContext(options) {
    public DbSet<Opportunity> Opportunities { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder) => modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) => optionsBuilder.EnableSensitiveDataLogging();
}