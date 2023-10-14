using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sonorus.PostAPI.Data.Entities;

[Table("Interests")]
public class Interest {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
    public long InterestId { get; set; }

    public ICollection<Post> Posts { get; set; } = new List<Post>();
}