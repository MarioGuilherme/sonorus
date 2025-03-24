using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sonorus.Account.Core.Entities;

namespace Sonorus.Account.Infrastructure.Persistence.Configurations;

public class UserConfiguration : IEntityTypeConfiguration<User> {
    public void Configure(EntityTypeBuilder<User> builder) {
        builder.HasKey(u => u.UserId);

        builder.HasIndex(u => u.Email).IsUnique();
        builder.HasIndex(u => u.Nickname).IsUnique();

        builder.Property(u => u.Fullname).HasMaxLength(60);
        builder.Property(u => u.Nickname).HasMaxLength(25);
        builder.Property(u => u.Email).HasMaxLength(60);
        builder.Property(u => u.Password).HasMaxLength(60);
        builder.Property(u => u.Picture).HasMaxLength(41);
        builder.Property(u => u.Picture).IsRequired(false);

        builder
            .HasOne(u => u.RefreshToken)
            .WithOne(rf => rf.User)
            .HasForeignKey(typeof(RefreshToken), nameof(RefreshToken.UserId))
            .OnDelete(DeleteBehavior.Restrict);

        builder
            .HasMany(u => u.Interests)
            .WithMany(i => i.Users)
            .UsingEntity(
                "UsersInterests",
                l => l.HasOne(typeof(Interest)).WithMany().HasForeignKey(nameof(Interest.InterestId)).HasPrincipalKey(nameof(Interest.InterestId)),
                r => r.HasOne(typeof(User)).WithMany().HasForeignKey(nameof(User.UserId)).HasPrincipalKey(nameof(User.UserId)),
                j => j.HasKey(nameof(User.UserId), nameof(Interest.InterestId))
            );
    }
}