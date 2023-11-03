using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Sonorus.PostAPI.Data.Entities;

[Table("Comments")]
public class Comment {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long? CommentId { get; set; }

    public long UserId { get; set; }

    [Required]
    [StringLength(100)]
    public string Content { get; set; } = null!;

    public DateTime CommentedAt { get; set; }

    public Post Post { get; set; } = null!;

    public ICollection<CommentLiker> Likers { get; set; } = new List<CommentLiker>();
}