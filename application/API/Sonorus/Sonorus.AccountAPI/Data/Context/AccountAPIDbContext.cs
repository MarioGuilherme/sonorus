using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Data.Entities;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Data.Context;

public class AccountAPIDbContext : DbContext {
    public AccountAPIDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder) {
        builder.Entity<User>().HasIndex(u => u.Email).IsUnique();
        builder.Entity<User>().HasIndex(u => u.Nickname).IsUnique();
        builder.Entity<User>()
        .HasMany(u => u.Interests)
        .WithMany(i => i.Users)
        .UsingEntity(
            "UsersInterests",
            l => l.HasOne(typeof(Interest)).WithMany().HasForeignKey("InterestId").HasPrincipalKey(nameof(Interest.InterestId)),
            r => r.HasOne(typeof(User)).WithMany().HasForeignKey("UserId").HasPrincipalKey(nameof(User.UserId)),
            j => j.HasKey("UserId", "InterestId")
        );

        builder.Entity<Interest>().HasIndex(i => i.Key).IsUnique();

        builder.Entity<Interest>().HasData(new Interest[] {
            // Instrumentos
            new() {
                InterestId = 1,
                Key = "violao",
                Type = InterestType.Instrument,
                Value = "Violão"
            },
            new() {
                InterestId = 2,
                Key = "guitarra",
                Type = InterestType.Instrument,
                Value = "Guitarra"
            },
            new() {
                InterestId = 3,
                Key = "piano",
                Type = InterestType.Instrument,
                Value = "Piano"
            },
            new() {
                InterestId = 4,
                Key = "teclado",
                Type = InterestType.Instrument,
                Value = "Teclado"
            },
            new() {
                InterestId = 5,
                Key = "baixo",
                Type = InterestType.Instrument,
                Value = "Baixo"
            },
            new() {
                InterestId = 6,
                Key = "violino",
                Type = InterestType.Instrument,
                Value = "Violino"
            },
            new() {
                InterestId = 7,
                Key = "violoncelo",
                Type = InterestType.Instrument,
                Value = "Violoncelo"
            },
            new() {
                InterestId = 8,
                Key = "flauta",
                Type = InterestType.Instrument,
                Value = "Flauta"
            },
            new() {
                InterestId = 9,
                Key = "clarinete",
                Type = InterestType.Instrument,
                Value = "Clarinete"
            },
            new() {
                InterestId = 10,
                Key = "saxofone",
                Type = InterestType.Instrument,
                Value = "Saxofone"
            },
            new() {
                InterestId = 11,
                Key = "bateria",
                Type = InterestType.Instrument,
                Value = "Bateria"
            },
            new() {
                InterestId = 12,
                Key = "cavaquinho",
                Type = InterestType.Instrument,
                Value = "Cavaquinho"
            },
            new() {
                InterestId = 13,
                Key = "ukulele",
                Type = InterestType.Instrument,
                Value = "Ukulele"
            },
            new() {
                InterestId = 14,
                Key = "sintetizador",
                Type = InterestType.Instrument,
                Value = "Sintetizador"
            },
            new() {
                InterestId = 15,
                Key = "vocal",
                Type = InterestType.Instrument,
                Value = "Vocal"
            },
            new() {
                InterestId = 16,
                Key = "backing-vocal",
                Type = InterestType.Instrument,
                Value = "Backing Vocal"
            },

            // Bandas ou artistas
            new() {
                InterestId = 17,
                Key = "rhcp",
                Type = InterestType.BandOrArtist,
                Value = "Red Hot Chili Peppers"
            },
            new() {
                InterestId = 18,
                Key = "audioslave",
                Type = InterestType.BandOrArtist,
                Value = "Audioslave"
            },
            new() {
                InterestId = 19,
                Key = "nirvana",
                Type = InterestType.BandOrArtist,
                Value = "Nirvana"
            },
            new() {
                InterestId = 20,
                Key = "gorillaz",
                Type = InterestType.BandOrArtist,
                Value = "Gorillaz"
            },
            new() {
                InterestId = 21,
                Key = "queen",
                Type = InterestType.BandOrArtist,
                Value = "Queen"
            },
            new() {
                InterestId = 22,
                Key = "slipknot",
                Type = InterestType.BandOrArtist,
                Value = "Slipknot"
            },
            new() {
                InterestId = 23,
                Key = "iron-maiden",
                Type = InterestType.BandOrArtist,
                Value = "Iron Maiden"
            },
            new() {
                InterestId = 24,
                Key = "foo-fighters",
                Type = InterestType.BandOrArtist,
                Value = "Foo Fighters"
            },
            new() {
                InterestId = 25,
                Key = "radiohead",
                Type = InterestType.BandOrArtist,
                Value = "Radiohead"
            },
            new() {
                InterestId = 26,
                Key = "the-beatles",
                Type = InterestType.BandOrArtist,
                Value = "The Beatles"
            },
            new() {
                InterestId = 27,
                Key = "arctic-monkeys",
                Type = InterestType.BandOrArtist,
                Value = "Arctic Monkeys"
            },
            new() {
                InterestId = 28,
                Key = "rolling-stones",
                Type = InterestType.BandOrArtist,
                Value = "Rolling Stones"
            },
            new() {
                InterestId = 29,
                Key = "coldplay",
                Type = InterestType.BandOrArtist,
                Value = "Coldplay"
            },
            new() {
                InterestId = 30,
                Key = "guns-and-rose",
                Type = InterestType.BandOrArtist,
                Value = "Guns N' Rose"
            },
            new() {
                InterestId = 31,
                Key = "ze-ramalho",
                Type = InterestType.BandOrArtist,
                Value = "Zé Ramalho"
            },
            new() {
                InterestId = 32,
                Key = "legiao-urbana",
                Type = InterestType.BandOrArtist,
                Value = "Legião Urbana"
            },
            new() {
                InterestId = 33,
                Key = "engenheiros-do-hawaii",
                Type = InterestType.BandOrArtist,
                Value = "Engenheiros do Hawaii"
            },
            new() {
                InterestId = 34,
                Key = "dave-grohl",
                Type = InterestType.BandOrArtist,
                Value = "Dave Grohl"
            },
            new() {
                InterestId = 35,
                Key = "titas",
                Type = InterestType.BandOrArtist,
                Value = "Titãs"
            },
            new() {
                InterestId = 36,
                Key = "john-frusciante",
                Type = InterestType.BandOrArtist,
                Value = "John Frusciante"
            },
            new() {
                InterestId = 37,
                Key = "kurt-cobain",
                Type = InterestType.BandOrArtist,
                Value = "Kurt Cobain"
            },
            new() {
                InterestId = 38,
                Key = "michael-jackson",
                Type = InterestType.BandOrArtist,
                Value = "Michael Jackson"
            },

            // Gêneros Musicais
            new() {
                InterestId = 39,
                Key = "rock",
                Type = InterestType.MusicalGenre,
                Value = "Rock"
            },
            new() {
                InterestId = 40,
                Key = "pop",
                Type = InterestType.MusicalGenre,
                Value = "Pop"
            },
            new() {
                InterestId = 41,
                Key = "samba",
                Type = InterestType.MusicalGenre,
                Value = "Samba"
            },
            new() {
                InterestId = 42,
                Key = "pagode",
                Type = InterestType.MusicalGenre,
                Value = "Pagode"
            },
            new() {
                InterestId = 43,
                Key = "mpb",
                Type = InterestType.MusicalGenre,
                Value = "MPB"
            },
            new() {
                InterestId = 44,
                Key = "rock-alternativo",
                Type = InterestType.MusicalGenre,
                Value = "Rock Alternativo"
            },
            new() {
                InterestId = 45,
                Key = "indie",
                Type = InterestType.MusicalGenre,
                Value = "Indie"
            },
            new() {
                InterestId = 46,
                Key = "jazz",
                Type = InterestType.MusicalGenre,
                Value = "Jazz"
            },
            new() {
                InterestId = 47,
                Key = "eletronica",
                Type = InterestType.MusicalGenre,
                Value = "Eletrônica"
            },
            new() {
                InterestId = 48,
                Key = "classica",
                Type = InterestType.MusicalGenre,
                Value = "Clássica"
            },
            new() {
                InterestId = 49,
                Key = "punk",
                Type = InterestType.MusicalGenre,
                Value = "Punk"
            }
        });
    }

    public DbSet<User> Users { get; set; }
    public DbSet<Interest> Interests { get; set; }
    public DbSet<RefreshToken> RefreshTokens { get; set; }
}