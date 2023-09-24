using Microsoft.EntityFrameworkCore;

namespace Sonorus.AccountAPI.Data.Context;

public class AccountAPIDbContext : DbContext {
    public AccountAPIDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder) {
        builder.Entity<User>().HasIndex(u => u.Email).IsUnique();
        builder.Entity<User>().HasIndex(u => u.Nickname).IsUnique();
        builder.Entity<User>().Property(u => u.Picture).HasDefaultValue("defaultPicture.png");
        builder.Entity<User>()
        .HasMany(u => u.Interests)
        .WithMany(i => i.Users)
        .UsingEntity(
            "UsersInterests",
            l => l.HasOne(typeof(Interest)).WithMany().HasForeignKey("InterestId").HasPrincipalKey(nameof(Interest.IdInterest)),
            r => r.HasOne(typeof(User)).WithMany().HasForeignKey("UserId").HasPrincipalKey(nameof(User.IdUser)),
            j => j.HasKey("UserId", "InterestId")
        );

        builder.Entity<Interest>().HasIndex(i => i.Key).IsUnique();
    }

    public DbSet<User> Users { get; set; }
    public DbSet<Interest> Interests { get; set; }
}