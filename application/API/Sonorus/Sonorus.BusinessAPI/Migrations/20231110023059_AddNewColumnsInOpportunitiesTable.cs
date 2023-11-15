using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.BusinessAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddNewColumnsInOpportunitiesTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsWork",
                table: "Opportunities",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "WorkUnit",
                table: "Opportunities",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsWork",
                table: "Opportunities");

            migrationBuilder.DropColumn(
                name: "WorkUnit",
                table: "Opportunities");
        }
    }
}
