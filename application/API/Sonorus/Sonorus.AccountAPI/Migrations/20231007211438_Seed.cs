using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Sonorus.AccountAPI.Migrations
{
    /// <inheritdoc />
    public partial class Seed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Interests",
                columns: new[] { "IdInterest", "Key", "Type", "Value" },
                values: new object[,]
                {
                    { 1L, "rhcp", 0, "Red Hot Chili Peppers" },
                    { 2L, "nirvana", 0, "Nirvana" },
                    { 3L, "queen", 0, "Queen" },
                    { 4L, "guitar", 2, "Guitarra" },
                    { 5L, "acoustic-guitar", 2, "Violão" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "IdInterest",
                keyValue: 1L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "IdInterest",
                keyValue: 2L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "IdInterest",
                keyValue: 3L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "IdInterest",
                keyValue: 4L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "IdInterest",
                keyValue: 5L);
        }
    }
}
