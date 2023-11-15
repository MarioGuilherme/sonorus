using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.BusinessAPI.Migrations
{
    /// <inheritdoc />
    public partial class OthersImprovementsInOpportunitiesTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "TimeExperience",
                table: "Opportunities",
                newName: "ExperienceRequired");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "ExperienceRequired",
                table: "Opportunities",
                newName: "TimeExperience");
        }
    }
}
