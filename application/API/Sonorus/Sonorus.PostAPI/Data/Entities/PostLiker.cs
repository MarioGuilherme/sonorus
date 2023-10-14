using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sonorus.PostAPI.Data.Entities;

[Table("PostLikers")]
public class PostLiker {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long PostLikerId { get; set; }
    public long UserId { get; set; }
}