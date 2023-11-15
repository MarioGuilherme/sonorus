namespace Sonorus.AccountAPI.DTO;

public class OpportunityDTO {
    public long OpportunityId { get; set; }

    public string Name { get; set; } = null!;

    public string ExperienceRequired { get; set; } = null!;

    public DateTime AnnouncedAt { get; set; }
}