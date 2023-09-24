using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Data;

[Table("Interests")]
public class Interest {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long? IdInterest { get; set; }

    [Required]
    [StringLength(60)]
    public string? Key { get; set; }

    [Required]
    [StringLength(60)]
    public string? Value { get; set; }

    public InterestType Type { get; set; }

    public ICollection<User> Users { get; set; } = new List<User>();
}