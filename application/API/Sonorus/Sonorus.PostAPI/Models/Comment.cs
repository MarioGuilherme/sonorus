using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sonorus.PostAPI.Models;

[Table("Comments")]
public class Comment {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long IdComment { get; set; }

    public long IdPost { get; set; }

    [Required]
    [StringLength(400)]
    public string Content { get; set; } = string.Empty;

    [ForeignKey("IdPost")]
    public virtual Post Post { get; set; } = null!;
}