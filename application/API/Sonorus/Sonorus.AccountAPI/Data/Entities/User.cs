using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using static BCrypt.Net.BCrypt;

namespace Sonorus.AccountAPI.Data.Entities;

[Table("Users")]
public class User {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long? UserId { get; set; }

    [Required]
    [StringLength(100)]
    public string Fullname { get; set; } = null!;

    [Required]
    [StringLength(25)]
    public string Nickname { get; set; } = null!;

    [Required]
    [StringLength(100)]
    public string Email { get; set; } = null!;

    private string _password = null!;

    [Required]
    [StringLength(60)]
    public string Password {
        get => _password;
        set => _password = HashPassword(value);
    }

    [StringLength(maximumLength: 41)]
    public string? Picture { get; set; }

    public ICollection<Interest> Interests { get; set; } = new List<Interest>();
}