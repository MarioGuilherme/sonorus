using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.AccountAPI.Migrations
{
    /// <inheritdoc />
    public partial class TableOfInterest : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Interests",
                columns: table => new
                {
                    IdInterest = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Key = table.Column<string>(type: "nvarchar(60)", maxLength: 60, nullable: false),
                    Value = table.Column<string>(type: "nvarchar(60)", maxLength: 60, nullable: false),
                    Type = table.Column<int>(type: "int", nullable: false),
                    UserIdUser = table.Column<long>(type: "bigint", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Interests", x => x.IdInterest);
                    table.ForeignKey(
                        name: "FK_Interests_Users_UserIdUser",
                        column: x => x.UserIdUser,
                        principalTable: "Users",
                        principalColumn: "IdUser");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Interests_UserIdUser",
                table: "Interests",
                column: "UserIdUser");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Interests");
        }
    }
}
