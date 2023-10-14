using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.PostAPI.Migrations
{
    /// <inheritdoc />
    public partial class TableMediaColumnPathLength : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "Path",
                table: "Medias",
                type: "nvarchar(41)",
                maxLength: 41,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(35)",
                oldMaxLength: 35);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "Path",
                table: "Medias",
                type: "nvarchar(35)",
                maxLength: 35,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(41)",
                oldMaxLength: 41);
        }
    }
}
