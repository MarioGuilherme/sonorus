using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using static BCrypt.Net.BCrypt;

namespace Sonorus.AccountAPI.Models;

[Table("Users")]
public class User {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long? IdUser { get; set; }

    [Required]
    [StringLength(100)]
    public string? Fullname { get; set; }

    [Required]
    [StringLength(25)]
    public string? Nickname { get; set; }

    [Required]
    [StringLength(100)]
    public string? Email { get; set; }

    private string? _password;

    [Required]
    [StringLength(60)]
    public string? Password {
        get => this._password;
        set => this._password = HashPassword(value);
    }

    [StringLength(41)]
    public string? Picture { get; set; }

    public ICollection<Interest> Interests { get; set; } = new List<Interest>();
}