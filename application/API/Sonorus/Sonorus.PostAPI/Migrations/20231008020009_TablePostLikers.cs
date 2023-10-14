using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.PostAPI.Migrations
{
    /// <inheritdoc />
    public partial class TablePostLikers : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.CreateTable(
                name: "PostLikers",
                columns: table => new
                {
                    IdPostLiker = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IdUser = table.Column<long>(type: "bigint", nullable: false),
                    PostIdPost = table.Column<long>(type: "bigint", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PostLikers", x => x.IdPostLiker);
                    table.ForeignKey(
                        name: "FK_PostLikers_Posts_PostIdPost",
                        column: x => x.PostIdPost,
                        principalTable: "Posts",
                        principalColumn: "IdPost");
                });

            migrationBuilder.CreateIndex(
                name: "IX_PostLikers_PostIdPost",
                table: "PostLikers",
                column: "PostIdPost");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PostLikers");

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    IdUser = table.Column<long>(type: "bigint", nullable: false),
                    Nickname = table.Column<string>(type: "nvarchar(25)", maxLength: 25, nullable: false),
                    Picture = table.Column<string>(type: "nvarchar(41)", maxLength: 41, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.IdUser);
                });
        }
    }
}
