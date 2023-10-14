using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.AccountAPI.Migrations
{
    /// <inheritdoc />
    public partial class FixInInTheSuffix : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "IdUser",
                table: "Users",
                newName: "UserId");

            migrationBuilder.RenameColumn(
                name: "IdInterest",
                table: "Interests",
                newName: "InterestId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "Users",
                newName: "IdUser");

            migrationBuilder.RenameColumn(
                name: "InterestId",
                table: "Interests",
                newName: "IdInterest");
        }
    }
}
