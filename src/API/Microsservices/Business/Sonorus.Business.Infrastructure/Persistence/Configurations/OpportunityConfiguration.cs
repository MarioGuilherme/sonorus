using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using Sonorus.Business.Core.Entities;

namespace Sonorus.Business.Infrastructure.Persistence.Configurations;

public class OpportunityConfiguration : IEntityTypeConfiguration<Opportunity> {
    public void Configure(EntityTypeBuilder<Opportunity> builder) {
        builder.HasKey(o => o.OpportunityId);

        builder.Property(o => o.RecruiterId).HasMaxLength(50);
        builder.Property(o => o.Name).HasMaxLength(50);
        builder.Property(o => o.BandName).HasMaxLength(50);
        builder.Property(o => o.Description).HasMaxLength(255);
        builder.Property(o => o.ExperienceRequired).HasMaxLength(25);
        builder.Property(o => o.Payment).HasColumnType("decimal(18, 2)");
        builder.Property(o => o.AnnouncedAt).HasDefaultValueSql("GETDATE()");
    }
}