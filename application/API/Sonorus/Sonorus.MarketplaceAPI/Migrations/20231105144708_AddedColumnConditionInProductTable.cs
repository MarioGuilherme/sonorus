using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.MarketplaceAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddedColumnConditionInProductTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<DateTime>(
                name: "AnnouncedAt",
                table: "Products",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 11, 5, 11, 47, 8, 783, DateTimeKind.Local).AddTicks(1187),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 11, 3, 1, 12, 53, 230, DateTimeKind.Local).AddTicks(257));

            migrationBuilder.AddColumn<int>(
                name: "Condition",
                table: "Products",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Condition",
                table: "Products");

            migrationBuilder.AlterColumn<DateTime>(
                name: "AnnouncedAt",
                table: "Products",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 11, 3, 1, 12, 53, 230, DateTimeKind.Local).AddTicks(257),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 11, 5, 11, 47, 8, 783, DateTimeKind.Local).AddTicks(1187));
        }
    }
}
