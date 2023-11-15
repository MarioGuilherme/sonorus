using Sonorus.BusinessAPI.Models;

namespace Sonorus.BusinessAPI.DTO;

public class OpportunityDTO {
    public long OpportunityId { get; set; }

    public UserDTO Recruiter { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? BandName { get; set; }

    public string? Description { get; set; }

    public string ExperienceRequired { get; set; } = null!;

    public decimal Payment { get; set; }

    public bool IsWork { get; set; }

    public WorkTimeUnit? WorkTimeUnit { get; set; }

    public DateTime AnnouncedAt { get; set; }
}