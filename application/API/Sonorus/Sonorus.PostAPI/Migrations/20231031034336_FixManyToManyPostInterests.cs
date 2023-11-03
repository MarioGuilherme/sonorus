using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.PostAPI.Migrations
{
    /// <inheritdoc />
    public partial class FixManyToManyPostInterests : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "InterestPost");

            migrationBuilder.AlterColumn<DateTime>(
                name: "PostedAt",
                table: "Posts",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 31, 0, 43, 35, 931, DateTimeKind.Local).AddTicks(5793),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 10, 12, 19, 16, 4, 5, DateTimeKind.Local).AddTicks(7685));

            migrationBuilder.AlterColumn<DateTime>(
                name: "CommentedAt",
                table: "Comments",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 31, 0, 43, 35, 931, DateTimeKind.Local).AddTicks(6240),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 10, 12, 19, 16, 4, 5, DateTimeKind.Local).AddTicks(8085));

            migrationBuilder.CreateTable(
                name: "InterestsPosts",
                columns: table => new
                {
                    PostId = table.Column<long>(type: "bigint", nullable: false),
                    InterestId = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InterestsPosts", x => new { x.PostId, x.InterestId });
                    table.ForeignKey(
                        name: "FK_InterestsPosts_Interests_InterestId",
                        column: x => x.InterestId,
                        principalTable: "Interests",
                        principalColumn: "InterestId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_InterestsPosts_Posts_PostId",
                        column: x => x.PostId,
                        principalTable: "Posts",
                        principalColumn: "PostId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Interests",
                column: "InterestId",
                values: new object[]
                {
                    1L,
                    2L,
                    3L,
                    4L,
                    5L
                });

            migrationBuilder.CreateIndex(
                name: "IX_InterestsPosts_InterestId",
                table: "InterestsPosts",
                column: "InterestId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "InterestsPosts");

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 1L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 2L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 3L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 4L);

            migrationBuilder.DeleteData(
                table: "Interests",
                keyColumn: "InterestId",
                keyValue: 5L);

            migrationBuilder.AlterColumn<DateTime>(
                name: "PostedAt",
                table: "Posts",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 12, 19, 16, 4, 5, DateTimeKind.Local).AddTicks(7685),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 10, 31, 0, 43, 35, 931, DateTimeKind.Local).AddTicks(5793));

            migrationBuilder.AlterColumn<DateTime>(
                name: "CommentedAt",
                table: "Comments",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 12, 19, 16, 4, 5, DateTimeKind.Local).AddTicks(8085),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 10, 31, 0, 43, 35, 931, DateTimeKind.Local).AddTicks(6240));

            migrationBuilder.CreateTable(
                name: "InterestPost",
                columns: table => new
                {
                    InterestsInterestId = table.Column<long>(type: "bigint", nullable: false),
                    PostsPostId = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InterestPost", x => new { x.InterestsInterestId, x.PostsPostId });
                    table.ForeignKey(
                        name: "FK_InterestPost_Interests_InterestsInterestId",
                        column: x => x.InterestsInterestId,
                        principalTable: "Interests",
                        principalColumn: "InterestId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_InterestPost_Posts_PostsPostId",
                        column: x => x.PostsPostId,
                        principalTable: "Posts",
                        principalColumn: "PostId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_InterestPost_PostsPostId",
                table: "InterestPost",
                column: "PostsPostId");
        }
    }
}
