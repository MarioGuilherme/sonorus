using Microsoft.EntityFrameworkCore;
using Sonorus.Account.Core.Entities;
using System.Reflection;

namespace Sonorus.Account.Infrastructure.Persistence;

public class SonorusAccountDbContext(DbContextOptions<SonorusAccountDbContext> options) : DbContext(options) {
    public DbSet<RefreshToken> RefreshTokens { get; set; }
    public DbSet<Interest> Interests { get; set; }
    public DbSet<User> Users { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder) => modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) => optionsBuilder.EnableSensitiveDataLogging();
}