using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.AccountAPI.Migrations
{
    /// <inheritdoc />
    public partial class UserColumnPictureNotNullable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "Picture",
                table: "Users",
                type: "nvarchar(41)",
                maxLength: 41,
                nullable: false,
                defaultValue: "defaultPicture.png",
                oldClrType: typeof(string),
                oldType: "nvarchar(41)",
                oldMaxLength: 41,
                oldNullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "Picture",
                table: "Users",
                type: "nvarchar(41)",
                maxLength: 41,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(41)",
                oldMaxLength: 41,
                oldDefaultValue: "defaultPicture.png");
        }
    }
}
