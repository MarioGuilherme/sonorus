using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sonorus.PostAPI.Models;

[Table("Posts")]
public class Post {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long IdPost { get; set; }

    [Required]
    [StringLength(1000)]
    public string Content { get; set; }
}