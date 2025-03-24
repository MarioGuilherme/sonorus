using Sonorus.Business.Core.Enums;

namespace Sonorus.Business.Application.Commands.UpdateOpportunity;

public class UpdateOpportunityInputModel(string name, string? bandName, string? description, string experienceRequired, decimal payment, bool isWork, WorkTimeUnit? workTimeUnit) {
    public string Name { get; private set; } = name;
    public string? BandName { get; private set; } = bandName;
    public string? Description { get; private set; } = description;
    public string ExperienceRequired { get; private set; } = experienceRequired;
    public decimal Payment { get; private set; } = payment;
    public bool IsWork { get; private set; } = isWork;
    public WorkTimeUnit? WorkTimeUnit { get; private set; } = workTimeUnit;
}