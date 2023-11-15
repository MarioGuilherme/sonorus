using Sonorus.BusinessAPI.Models;

namespace Sonorus.BusinessAPI.DTO;

public class OpportunityRegisterDTO {
    public long OpportunityId { get; set; }

    public string Name { get; set; } = null!;

    public string? BandName { get; set; }

    public string? Description { get; set; }

    public string ExperienceRequired { get; set; } = null!;

    public double Payment { get; set; }

    public bool IsWork { get; set; }

    public WorkTimeUnit? WorkTimeUnit { get; set; }
}