using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.AccountAPI.Migrations
{
    /// <inheritdoc />
    public partial class TableOfUsersInterests : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "UsersInterests",
                columns: table => new
                {
                    IdUserInterest = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IdUser = table.Column<long>(type: "bigint", nullable: true),
                    IdInterest = table.Column<long>(type: "bigint", nullable: true),
                    UserIdUser = table.Column<long>(type: "bigint", nullable: false),
                    InterestIdInterest = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UsersInterests", x => x.IdUserInterest);
                    table.ForeignKey(
                        name: "FK_UsersInterests_Interests_InterestIdInterest",
                        column: x => x.InterestIdInterest,
                        principalTable: "Interests",
                        principalColumn: "IdInterest",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UsersInterests_Users_UserIdUser",
                        column: x => x.UserIdUser,
                        principalTable: "Users",
                        principalColumn: "IdUser",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Interests_Key",
                table: "Interests",
                column: "Key",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UsersInterests_InterestIdInterest",
                table: "UsersInterests",
                column: "InterestIdInterest");

            migrationBuilder.CreateIndex(
                name: "IX_UsersInterests_UserIdUser",
                table: "UsersInterests",
                column: "UserIdUser");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UsersInterests");

            migrationBuilder.DropIndex(
                name: "IX_Interests_Key",
                table: "Interests");
        }
    }
}
