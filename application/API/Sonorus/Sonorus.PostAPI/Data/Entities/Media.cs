using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace Sonorus.PostAPI.Data.Entities;

[Table("Medias")]
public class Media {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long? MediaId { get; set; }

    [Required]
    [StringLength(maximumLength: 41)]
    public string Path { get; set; } = null!;

    public Post Post { get; set; } = null!;
}