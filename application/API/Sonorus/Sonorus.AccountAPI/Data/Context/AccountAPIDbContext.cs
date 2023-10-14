using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Data.Entities;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Data.Context;

public class AccountAPIDbContext : DbContext {
    public AccountAPIDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder) {
        builder.Entity<User>().HasIndex(u => u.Email).IsUnique();
        builder.Entity<User>().HasIndex(u => u.Nickname).IsUnique();
        builder.Entity<User>()
        .HasMany(u => u.Interests)
        .WithMany(i => i.Users)
        .UsingEntity(
            "UsersInterests",
            l => l.HasOne(typeof(Interest)).WithMany().HasForeignKey("InterestId").HasPrincipalKey(nameof(Interest.InterestId)),
            r => r.HasOne(typeof(User)).WithMany().HasForeignKey("UserId").HasPrincipalKey(nameof(User.UserId)),
            j => j.HasKey("UserId", "InterestId")
        );

        builder.Entity<Interest>().HasIndex(i => i.Key).IsUnique();

        builder.Entity<Interest>().HasData(new Interest[] {
            new() {
                InterestId = 1,
                Key = "rhcp",
                Value = "Red Hot Chili Peppers",
                Type = InterestType.Band
            },
            new() {
                InterestId = 2,
                Key = "nirvana",
                Value = "Nirvana",
                Type = InterestType.Band
            },
            new() {
                InterestId = 3,
                Key = "queen",
                Value = "Queen",
                Type = InterestType.Band
            },
            new() {
                InterestId = 4,
                Key = "guitar",
                Value = "Guitarra",
                Type = InterestType.Skill
            },
            new() {
                InterestId = 5,
                Key = "acoustic-guitar",
                Value = "Violão",
                Type = InterestType.Skill
            }
        });
    }

    public DbSet<User> Users { get; set; }
    public DbSet<Interest> Interests { get; set; }
}