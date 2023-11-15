using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Sonorus.PostAPI.Data.Entities;

[Table("Posts")]
public class Post {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long? PostId { get; set; }

    [Required]
    public long UserId { get; set; }

    [StringLength(255)]
    public string? Content { get; set; }

    public DateTime PostedAt { get; set; }

    public ICollection<PostLiker> Likers { get; set; } = new List<PostLiker>();

    public ICollection<Media> Medias { get; set; } = new List<Media>();

    public ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public ICollection<Interest> Interests { get; set; } = new List<Interest>();

    [StringLength(1000)]
    public string? Tablature { get; set; }
}