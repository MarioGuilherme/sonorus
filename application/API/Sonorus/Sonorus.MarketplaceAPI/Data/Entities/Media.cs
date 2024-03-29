﻿using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace Sonorus.MarketplaceAPI.Data.Entities;

[Table("Medias")]
public class Media {
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long? MediaId { get; set; }

    [Required]
    [StringLength(maximumLength: 41)]
    public string Path {
        get => $"{Environment.GetEnvironmentVariable("StorageBaseURL")}{Environment.GetEnvironmentVariable("StorageContainer")}/{this._path}";
        set => this._path = value;
    }
    private string _path = null!;

    public long ProductId { get; set; }
    public Product Product { get; set; } = null!;
}