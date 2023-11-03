using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sonorus.AccountAPI.Data.Entities;

[Table("RefreshTokens")]
public class RefreshToken {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long RefreshTokenId { get; set; }

    [Required]
    public long UserId { get; set; }

    [Required]
    [StringLength(45)]
    public string Token { get; set; } = null!;
}