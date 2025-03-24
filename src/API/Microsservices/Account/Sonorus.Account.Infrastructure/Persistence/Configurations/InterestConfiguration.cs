using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Enums;

namespace Sonorus.Account.Infrastructure.Persistence.Configurations;

public class InterestConfiguration : IEntityTypeConfiguration<Interest> {
    public void Configure(EntityTypeBuilder<Interest> builder) {
        builder.HasKey(i => i.InterestId);

        builder.HasIndex(i => i.Key).IsUnique();

        builder.Property(i => i.Key).HasMaxLength(60);
        builder.Property(i => i.Value).HasMaxLength(60);

        builder
            .HasMany(i => i.Users)
            .WithMany(u => u.Interests);
    }
}