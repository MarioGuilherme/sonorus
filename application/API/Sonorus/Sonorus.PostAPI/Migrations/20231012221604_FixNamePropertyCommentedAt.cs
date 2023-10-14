using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.PostAPI.Migrations
{
    /// <inheritdoc />
    public partial class FixNamePropertyCommentedAt : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CommentAt",
                table: "Comments");

            migrationBuilder.AlterColumn<DateTime>(
                name: "PostedAt",
                table: "Posts",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 12, 19, 16, 4, 5, DateTimeKind.Local).AddTicks(7685),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 10, 12, 18, 34, 40, 314, DateTimeKind.Local).AddTicks(8547));

            migrationBuilder.AddColumn<DateTime>(
                name: "CommentedAt",
                table: "Comments",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 12, 19, 16, 4, 5, DateTimeKind.Local).AddTicks(8085));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CommentedAt",
                table: "Comments");

            migrationBuilder.AlterColumn<DateTime>(
                name: "PostedAt",
                table: "Posts",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 12, 18, 34, 40, 314, DateTimeKind.Local).AddTicks(8547),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 10, 12, 19, 16, 4, 5, DateTimeKind.Local).AddTicks(7685));

            migrationBuilder.AddColumn<DateTime>(
                name: "CommentAt",
                table: "Comments",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 12, 18, 34, 40, 314, DateTimeKind.Local).AddTicks(8943));
        }
    }
}
