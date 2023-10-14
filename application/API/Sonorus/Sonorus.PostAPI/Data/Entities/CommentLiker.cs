using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sonorus.PostAPI.Data.Entities;

[Table("CommentLikers")]
public class CommentLiker {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long CommentLikerId { get; set; }
    public long UserId { get; set; }
}