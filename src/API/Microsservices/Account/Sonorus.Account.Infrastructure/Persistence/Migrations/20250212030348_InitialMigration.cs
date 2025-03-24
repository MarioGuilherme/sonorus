using Microsoft.EntityFrameworkCore.Migrations;
using Sonorus.Account.Core.Enums;

#nullable disable

namespace Sonorus.Account.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class InitialMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Interests",
                columns: table => new
                {
                    InterestId = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Key = table.Column<string>(type: "nvarchar(60)", maxLength: 60, nullable: false),
                    Value = table.Column<string>(type: "nvarchar(60)", maxLength: 60, nullable: false),
                    Type = table.Column<byte>(type: "tinyint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Interests", x => x.InterestId);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    UserId = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Fullname = table.Column<string>(type: "nvarchar(60)", maxLength: 60, nullable: false),
                    Nickname = table.Column<string>(type: "nvarchar(25)", maxLength: 25, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(60)", maxLength: 60, nullable: false),
                    Password = table.Column<string>(type: "nvarchar(60)", maxLength: 60, nullable: false),
                    Picture = table.Column<string>(type: "nvarchar(41)", maxLength: 41, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.UserId);
                });

            migrationBuilder.CreateTable(
                name: "RefreshTokens",
                columns: table => new
                {
                    RefreshTokenId = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<long>(type: "bigint", nullable: false),
                    Token = table.Column<string>(type: "nvarchar(45)", maxLength: 45, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RefreshTokens", x => x.RefreshTokenId);
                    table.ForeignKey(
                        name: "FK_RefreshTokens_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "UsersInterests",
                columns: table => new
                {
                    UserId = table.Column<long>(type: "bigint", nullable: false),
                    InterestId = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UsersInterests", x => new { x.UserId, x.InterestId });
                    table.ForeignKey(
                        name: "FK_UsersInterests_Interests_InterestId",
                        column: x => x.InterestId,
                        principalTable: "Interests",
                        principalColumn: "InterestId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UsersInterests_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Interests_Key",
                table: "Interests",
                column: "Key",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_RefreshTokens_UserId",
                table: "RefreshTokens",
                column: "UserId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_Email",
                table: "Users",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_Nickname",
                table: "Users",
                column: "Nickname",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UsersInterests_InterestId",
                table: "UsersInterests",
                column: "InterestId");

            migrationBuilder.InsertData(
                table: "Interests",
                columns: ["Key", "Value", "Type"],
                values: new object[,]
                {
                    // Instrumentos
                    { "violao", "Violão", (byte)InterestType.Instrument },
                    { "guitarra", "Guitarra", (byte)InterestType.Instrument },
                    { "piano", "Piano", (byte)InterestType.Instrument },
                    { "teclado", "Teclado", (byte)InterestType.Instrument },
                    { "baixo", "Baixo", (byte)InterestType.Instrument },
                    { "violino", "Violino", (byte)InterestType.Instrument },
                    { "violoncelo", "Violoncelo", (byte)InterestType.Instrument },
                    { "flauta", "Flauta", (byte)InterestType.Instrument },
                    { "clarinete", "Clarinete", (byte)InterestType.Instrument },
                    { "saxofone", "Saxofone", (byte)InterestType.Instrument },
                    { "bateria", "Bateria", (byte)InterestType.Instrument },
                    { "cavaquinho", "Cavaquinho", (byte)InterestType.Instrument },
                    { "ukulele", "Ukulele", (byte)InterestType.Instrument },
                    { "sintetizador", "Sintetizador", (byte)InterestType.Instrument },
                    { "vocal", "Vocal", (byte)InterestType.Instrument },
                    { "backing-vocal", "Backing Vocal", (byte)InterestType.Instrument },

                    // Bandas
                    { "rhcp", "Red Hot Chili Peppers", (byte)InterestType.Band },
                    { "slipknot", "Slipknot", (byte)InterestType.Band },
                    { "korn", "Korn", (byte)InterestType.Band },
                    { "audioslave", "Audioslave", (byte)InterestType.Band },
                    { "nirvana", "Nirvana", (byte)InterestType.Band },
                    { "gorillaz", "Gorillaz", (byte)InterestType.Band },
                    { "queen", "Queen", (byte)InterestType.Band },
                    { "iron-maiden", "Iron Maiden", (byte)InterestType.Band },
                    { "foo-fighters", "Foo Fighters", (byte)InterestType.Band },
                    { "radiohead", "Radiohead", (byte)InterestType.Band },
                    { "the-beatles", "The Beatles", (byte)InterestType.Band },
                    { "arctic-monkeys", "Arctic Monkeys", (byte)InterestType.Band },
                    { "rolling-stones", "Rolling Stones", (byte)InterestType.Band },
                    { "coldplay", "Coldplay", (byte)InterestType.Band },
                    { "guns-and-rose", "Guns N' Rose", (byte)InterestType.Band },
                    { "legiao-urbana", "Legião Urbana", (byte)InterestType.Band },
                    { "engenheiros-do-hawaii", "Engenheiros do Hawaii", (byte)InterestType.Band },
                    { "titas", "Titãs", (byte)InterestType.Band },

                    // Artistas
                    { "ze-ramalho", "Zé Ramalho", (byte)InterestType.Artist },
                    { "dave-grohl", "Dave Grohl", (byte)InterestType.Artist },
                    { "john-frusciante", "John Frusciante", (byte)InterestType.Artist },
                    { "kurt-cobain", "Kurt Cobain", (byte)InterestType.Artist },
                    { "michael-jackson", "Michael Jackson", (byte)InterestType.Artist },

                    // Gêneros Musicais
                    { "rock", "Rock", (byte)InterestType.MusicalGenre },
                    { "pop", "Pop", (byte)InterestType.MusicalGenre },
                    { "samba", "Samba", (byte)InterestType.MusicalGenre },
                    { "forro", "forró", (byte)InterestType.MusicalGenre },
                    { "pagode", "Pagode", (byte)InterestType.MusicalGenre },
                    { "mpb", "MPB", (byte)InterestType.MusicalGenre },
                    { "rock-alternativo", "Rock Alternativo", (byte)InterestType.MusicalGenre },
                    { "indie", "Indie", (byte)InterestType.MusicalGenre },
                    { "jazz", "Jazz", (byte)InterestType.MusicalGenre },
                    { "eletronica", "Eletrônica", (byte)InterestType.MusicalGenre },
                    { "classica", "Clássica", (byte)InterestType.MusicalGenre },
                    { "punk", "Punk", (byte)InterestType.MusicalGenre }
                }
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RefreshTokens");

            migrationBuilder.DropTable(
                name: "UsersInterests");

            migrationBuilder.DropTable(
                name: "Interests");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
