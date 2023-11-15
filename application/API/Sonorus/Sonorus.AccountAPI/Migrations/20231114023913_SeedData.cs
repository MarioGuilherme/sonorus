using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Sonorus.AccountAPI.Migrations
{
    /// <inheritdoc />
    public partial class SeedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 1L,
                columns: new[] { "Key", "Type", "Value" },
                values: new object[] { "violao", 2, "Violão" });

            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 2L,
                columns: new[] { "Key", "Type", "Value" },
                values: new object[] { "guitarra", 2, "Guitarra" });

            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 3L,
                columns: new[] { "Key", "Type", "Value" },
                values: new object[] { "piano", 2, "Piano" });

            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 4L,
                columns: new[] { "Key", "Value" },
                values: new object[] { "teclado", "Teclado" });

            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 5L,
                columns: new[] { "Key", "Value" },
                values: new object[] { "baixo", "Baixo" });

            migrationBuilder.InsertData(
                table: "Interests",
                columns: new[] { "InterestId", "Key", "Type", "Value" },
                values: new object[,]
                {
                    { 6L, "violino", 2, "Violino" },
                    { 7L, "violoncelo", 2, "Violoncelo" },
                    { 8L, "flauta", 2, "Flauta" },
                    { 9L, "clarinete", 2, "Clarinete" },
                    { 10L, "saxofone", 2, "Saxofone" },
                    { 11L, "bateria", 2, "Bateria" },
                    { 12L, "cavaquinho", 2, "Cavaquinho" },
                    { 13L, "ukulele", 2, "Ukulele" },
                    { 14L, "sintetizador", 2, "Sintetizador" },
                    { 15L, "vocal", 2, "Vocal" },
                    { 16L, "backing-vocal", 2, "Backing Vocal" },
                    { 17L, "rhcp", 0, "Red Hot Chili Peppers" },
                    { 18L, "audioslave", 0, "Audioslave" },
                    { 19L, "nirvana", 0, "Nirvana" },
                    { 20L, "gorillaz", 0, "Gorillaz" },
                    { 21L, "queen", 0, "Queen" },
                    { 22L, "slipknot", 0, "Slipknot" },
                    { 23L, "iron-maiden", 0, "Iron Maiden" },
                    { 24L, "foo-fighters", 0, "Foo Fighters" },
                    { 25L, "radiohead", 0, "Radiohead" },
                    { 26L, "the-beatles", 0, "The Beatles" },
                    { 27L, "arctic-monkeys", 0, "Arctic Monkeys" },
                    { 28L, "rolling-stones", 0, "Rolling Stones" },
                    { 29L, "coldplay", 0, "Coldplay" },
                    { 30L, "guns-and-rose", 0, "Guns N' Rose" },
                    { 31L, "ze-ramalho", 0, "Zé Ramalho" },
                    { 32L, "legiao-urbana", 0, "Legião Urbana" },
                    { 33L, "engenheiros-do-hawaii", 0, "Engenheiros do Hawaii" },
                    { 34L, "dave-grohl", 0, "Dave Grohl" },
                    { 35L, "titas", 0, "Titãs" },
                    { 36L, "john-frusciante", 0, "John Frusciante" },
                    { 37L, "kurt-cobain", 0, "Kurt Cobain" },
                    { 38L, "michael-jackson", 0, "Michael Jackson" },
                    { 39L, "rock", 1, "Rock" },
                    { 40L, "pop", 1, "Pop" },
                    { 41L, "samba", 1, "Samba" },
                    { 42L, "pagode", 1, "Pagode" },
                    { 43L, "mpb", 1, "MPB" },
                    { 44L, "rock-alternativo", 1, "Rock Alternativo" },
                    { 45L, "indie", 1, "Indie" },
                    { 46L, "jazz", 1, "Jazz" },
                    { 47L, "eletronica", 1, "Eletrônica" },
                    { 48L, "classica", 1, "Clássica" },
                    { 49L, "punk", 1, "Punk" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 6L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 7L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 8L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 9L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 10L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 11L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 12L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 13L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 14L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 15L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 16L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 17L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 18L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 19L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 20L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 21L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 22L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 23L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 24L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 25L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 26L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 27L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 28L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 29L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 30L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 31L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 32L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 33L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 34L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 35L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 36L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 37L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 38L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 39L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 40L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 41L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 42L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 43L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 44L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 45L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 46L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 47L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 48L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 49L);

            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 1L,
                columns: new[] { "Key", "Type", "Value" },
                values: new object[] { "rhcp", 0, "Red Hot Chili Peppers" });

            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 2L,
                columns: new[] { "Key", "Type", "Value" },
                values: new object[] { "nirvana", 0, "Nirvana" });

            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 3L,
                columns: new[] { "Key", "Type", "Value" },
                values: new object[] { "queen", 0, "Queen" });

            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 4L,
                columns: new[] { "Key", "Value" },
                values: new object[] { "guitar", "Guitarra" });

            migrationBuilder.UpdateData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 5L,
                columns: new[] { "Key", "Value" },
                values: new object[] { "acoustic-guitar", "Violão" });
        }
    }
}
