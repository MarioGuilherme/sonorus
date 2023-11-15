using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.BusinessAPI.Migrations
{
    /// <inheritdoc />
    public partial class RemoveUnusedColumn : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AllowUnfit",
                table: "Opportunities");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "AllowUnfit",
                table: "Opportunities",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }
    }
}
