using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.MarketplaceAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddColunsNameAndDescriptionInProduct : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<DateTime>(
                name: "AnnouncedAt",
                table: "Products",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 11, 3, 1, 10, 23, 390, DateTimeKind.Local).AddTicks(3761),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 11, 2, 23, 31, 6, 298, DateTimeKind.Local).AddTicks(4258));

            migrationBuilder.AddColumn<string>(
                name: "Description",
                table: "Products",
                type: "nvarchar(255)",
                maxLength: 255,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Name",
                table: "Products",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Description",
                table: "Products");

            migrationBuilder.DropColumn(
                name: "Name",
                table: "Products");

            migrationBuilder.AlterColumn<DateTime>(
                name: "AnnouncedAt",
                table: "Products",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 11, 2, 23, 31, 6, 298, DateTimeKind.Local).AddTicks(4258),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 11, 3, 1, 10, 23, 390, DateTimeKind.Local).AddTicks(3761));
        }
    }
}
