using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.PostAPI.Migrations
{
    /// <inheritdoc />
    public partial class RemoveDatabaseGeneratedComputed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<DateTime>(
                name: "PostedAt",
                table: "Posts",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 11, 2, 23, 22, 35, 472, DateTimeKind.Local).AddTicks(9198),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 10, 31, 0, 43, 35, 931, DateTimeKind.Local).AddTicks(5793));

            migrationBuilder.AlterColumn<DateTime>(
                name: "CommentedAt",
                table: "Comments",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 11, 2, 23, 22, 35, 472, DateTimeKind.Local).AddTicks(9558),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 10, 31, 0, 43, 35, 931, DateTimeKind.Local).AddTicks(6240));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<DateTime>(
                name: "PostedAt",
                table: "Posts",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 31, 0, 43, 35, 931, DateTimeKind.Local).AddTicks(5793),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 11, 2, 23, 22, 35, 472, DateTimeKind.Local).AddTicks(9198));

            migrationBuilder.AlterColumn<DateTime>(
                name: "CommentedAt",
                table: "Comments",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 31, 0, 43, 35, 931, DateTimeKind.Local).AddTicks(6240),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 11, 2, 23, 22, 35, 472, DateTimeKind.Local).AddTicks(9558));
        }
    }
}
