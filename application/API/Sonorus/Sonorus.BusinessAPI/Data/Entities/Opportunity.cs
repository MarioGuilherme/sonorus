using Sonorus.BusinessAPI.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sonorus.BusinessAPI.Data.Entities;

[Table("Opportunities")]
public class Opportunity {
    public long OpportunityId { get; set; }

    public long RecruiterId { get; set; }

    [Required]
    [StringLength(50)]
    public string Name { get; set; } = null!;

    [StringLength(50)]
    public string? BandName { get; set; }

    [StringLength(255)]
    public string? Description { get; set; }

    [Required]
    [StringLength(25)]
    public string ExperienceRequired { get; set; } = null!;

    [Required]
    public decimal Payment { get; set; }

    public bool IsWork { get; set; }

    public WorkTimeUnit? WorkTimeUnit { get; set; }

    public DateTime AnnouncedAt { get; set; }
}