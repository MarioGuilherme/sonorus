using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.AccountAPI.Migrations
{
    /// <inheritdoc />
    public partial class ImprovementManyToMany : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Interests_Users_UserIdUser",
                table: "Interests");

            migrationBuilder.DropForeignKey(
                name: "FK_UsersInterests_Interests_InterestIdInterest",
                table: "UsersInterests");

            migrationBuilder.DropForeignKey(
                name: "FK_UsersInterests_Users_UserIdUser",
                table: "UsersInterests");

            migrationBuilder.DropPrimaryKey(
                name: "PK_UsersInterests",
                table: "UsersInterests");

            migrationBuilder.DropIndex(
                name: "IX_UsersInterests_InterestIdInterest",
                table: "UsersInterests");

            migrationBuilder.DropIndex(
                name: "IX_Interests_UserIdUser",
                table: "Interests");

            migrationBuilder.DropColumn(
                name: "IdUserInterest",
                table: "UsersInterests");

            migrationBuilder.DropColumn(
                name: "IdInterest",
                table: "UsersInterests");

            migrationBuilder.DropColumn(
                name: "IdUser",
                table: "UsersInterests");

            migrationBuilder.DropColumn(
                name: "UserIdUser",
                table: "Interests");

            migrationBuilder.RenameColumn(
                name: "UserIdUser",
                table: "UsersInterests",
                newName: "InterestId");

            migrationBuilder.RenameColumn(
                name: "InterestIdInterest",
                table: "UsersInterests",
                newName: "UserId");

            migrationBuilder.RenameIndex(
                name: "IX_UsersInterests_UserIdUser",
                table: "UsersInterests",
                newName: "IX_UsersInterests_InterestId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_UsersInterests",
                table: "UsersInterests",
                columns: new[] { "UserId", "InterestId" });

            migrationBuilder.AddForeignKey(
                name: "FK_UsersInterests_Interests_InterestId",
                table: "UsersInterests",
                column: "InterestId",
                principalTable: "Interests",
                principalColumn: "IdInterest",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UsersInterests_Users_UserId",
                table: "UsersInterests",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "IdUser",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UsersInterests_Interests_InterestId",
                table: "UsersInterests");

            migrationBuilder.DropForeignKey(
                name: "FK_UsersInterests_Users_UserId",
                table: "UsersInterests");

            migrationBuilder.DropPrimaryKey(
                name: "PK_UsersInterests",
                table: "UsersInterests");

            migrationBuilder.RenameColumn(
                name: "InterestId",
                table: "UsersInterests",
                newName: "UserIdUser");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "UsersInterests",
                newName: "InterestIdInterest");

            migrationBuilder.RenameIndex(
                name: "IX_UsersInterests_InterestId",
                table: "UsersInterests",
                newName: "IX_UsersInterests_UserIdUser");

            migrationBuilder.AddColumn<long>(
                name: "IdUserInterest",
                table: "UsersInterests",
                type: "bigint",
                nullable: false,
                defaultValue: 0L)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddColumn<long>(
                name: "IdInterest",
                table: "UsersInterests",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<long>(
                name: "IdUser",
                table: "UsersInterests",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<long>(
                name: "UserIdUser",
                table: "Interests",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_UsersInterests",
                table: "UsersInterests",
                column: "IdUserInterest");

            migrationBuilder.CreateIndex(
                name: "IX_UsersInterests_InterestIdInterest",
                table: "UsersInterests",
                column: "InterestIdInterest");

            migrationBuilder.CreateIndex(
                name: "IX_Interests_UserIdUser",
                table: "Interests",
                column: "UserIdUser");

            migrationBuilder.AddForeignKey(
                name: "FK_Interests_Users_UserIdUser",
                table: "Interests",
                column: "UserIdUser",
                principalTable: "Users",
                principalColumn: "IdUser");

            migrationBuilder.AddForeignKey(
                name: "FK_UsersInterests_Interests_InterestIdInterest",
                table: "UsersInterests",
                column: "InterestIdInterest",
                principalTable: "Interests",
                principalColumn: "IdInterest",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UsersInterests_Users_UserIdUser",
                table: "UsersInterests",
                column: "UserIdUser",
                principalTable: "Users",
                principalColumn: "IdUser",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
