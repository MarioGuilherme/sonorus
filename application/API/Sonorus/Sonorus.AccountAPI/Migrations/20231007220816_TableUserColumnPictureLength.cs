using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.AccountAPI.Migrations
{
    /// <inheritdoc />
    public partial class TableUserColumnPictureLength : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "Picture",
                table: "Users",
                type: "nvarchar(41)",
                maxLength: 41,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(96)",
                oldMaxLength: 96,
                oldNullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "Picture",
                table: "Users",
                type: "nvarchar(96)",
                maxLength: 96,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(41)",
                oldMaxLength: 41,
                oldNullable: true);
        }
    }
}
