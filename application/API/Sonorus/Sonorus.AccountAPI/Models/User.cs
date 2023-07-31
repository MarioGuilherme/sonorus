using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace Sonorus.AccountAPI.Models;

[Table("Users")]
public class User {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long IdUser { get; set; }
    [Required]
    [StringLength(150)]
    public string FullName { get; set; } = string.Empty;

    [Required]
    [StringLength(50)]
    public string Nickname { get; set; } = string.Empty;

    [Required]
    [StringLength(100)]
    public string Email { get; set; } = string.Empty;

    [Required]
    public string Password { get; set; } = string.Empty;
}