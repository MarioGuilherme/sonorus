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

    [Required]
    [StringLength(60)]
    public string Password {
        get => this._password;
        set => this._password = HashPassword(value);
    }
    private string _password = null!;

    [StringLength(maximumLength: 41)]
    public string? Picture {
        get => $"{Environment.GetEnvironmentVariable("StorageBaseURL")}{Environment.GetEnvironmentVariable("StorageContainer")}/{this._picture ?? "defaultPicture.png"}";
        set => this._picture = value;
    }
    private string? _picture;

    public ICollection<Interest> Interests { get; set; } = new List<Interest>();
}