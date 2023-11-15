using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.BusinessAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddColumnBandNameOpportunitiesTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "BandName",
                table: "Opportunities",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "BandName",
                table: "Opportunities");
        }
    }
}
