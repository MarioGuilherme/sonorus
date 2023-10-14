using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.PostAPI.Migrations
{
    /// <inheritdoc />
    public partial class TableCommentLikers : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CommentLikers",
                columns: table => new
                {
                    IdCommentLiker = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IdUser = table.Column<long>(type: "bigint", nullable: false),
                    CommentIdComment = table.Column<long>(type: "bigint", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CommentLikers", x => x.IdCommentLiker);
                    table.ForeignKey(
                        name: "FK_CommentLikers_Comments_CommentIdComment",
                        column: x => x.CommentIdComment,
                        principalTable: "Comments",
                        principalColumn: "IdComment");
                });

            migrationBuilder.CreateIndex(
                name: "IX_CommentLikers_CommentIdComment",
                table: "CommentLikers",
                column: "CommentIdComment");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CommentLikers");
        }
    }
}
