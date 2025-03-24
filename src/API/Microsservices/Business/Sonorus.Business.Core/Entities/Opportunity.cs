using Sonorus.Business.Core.Enums;

namespace Sonorus.Business.Core.Entities;

public class Opportunity(long recruiterId, string name, string? bandName, string? description, string experienceRequired, decimal payment, bool isWork, WorkTimeUnit? workTimeUnit) {
    public long OpportunityId { get; private set; }
    public long RecruiterId { get; private set; } = recruiterId;
    public string Name { get; private set; } = name;
    public string? BandName { get; private set; } = bandName;
    public string? Description { get; private set; } = description;
    public string ExperienceRequired { get; private set; } = experienceRequired;
    public decimal Payment { get; private set; } = payment;
    public bool IsWork { get; private set; } = isWork;
    public WorkTimeUnit? WorkTimeUnit { get; private set; } = workTimeUnit;
    public DateTime AnnouncedAt { get; private set; }

    public void Update(string name, string? bandName, string? description, string experienceRequired, decimal payment, bool IsWork, WorkTimeUnit? WorkTimeUnit) {
        this.Name = name;
        this.BandName = bandName;
        this.Description = description;
        this.ExperienceRequired = experienceRequired;
        this.Payment = payment;
        this.IsWork = IsWork;
        this.WorkTimeUnit = WorkTimeUnit;
    }
}