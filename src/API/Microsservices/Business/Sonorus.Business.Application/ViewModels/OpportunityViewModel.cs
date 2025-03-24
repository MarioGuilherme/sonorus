using Sonorus.Business.Core.Enums;

namespace Sonorus.Business.Application.ViewModels;

public record OpportunityViewModel(
    long OpportunityId,
    string Name,
    string? BandName,
    string? Description,
    string ExperienceRequired,
    decimal Payment,
    bool IsWork,
    WorkTimeUnit? WorkTimeUnit,
    DateTime AnnouncedAt
) {
    public UserViewModel Recruiter { get; set; } = null!;
}