using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Data;

public class SonorusDbContext : DbContext {
    public SonorusDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder) {
        builder.Entity<User>().HasIndex(u => u.Email).IsUnique();
        builder.Entity<User>().HasIndex(u => u.Nickname).IsUnique();
    }

    public DbSet<User> Users { get; set; }
}