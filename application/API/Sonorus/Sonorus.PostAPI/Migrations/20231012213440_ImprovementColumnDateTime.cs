using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sonorus.PostAPI.Migrations
{
    /// <inheritdoc />
    public partial class ImprovementColumnDateTime : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CommentLikers_Comments_CommentIdComment",
                table: "CommentLikers");

            migrationBuilder.DropForeignKey(
                name: "FK_Comments_Posts_IdPost",
                table: "Comments");

            migrationBuilder.DropForeignKey(
                name: "FK_InterestPost_Interests_InterestsIdInterest",
                table: "InterestPost");

            migrationBuilder.DropForeignKey(
                name: "FK_InterestPost_Posts_PostsIdPost",
                table: "InterestPost");

            migrationBuilder.DropForeignKey(
                name: "FK_Medias_Posts_IdPost",
                table: "Medias");

            migrationBuilder.DropForeignKey(
                name: "FK_PostLikers_Posts_PostIdPost",
                table: "PostLikers");

            migrationBuilder.RenameColumn(
                name: "IdUser",
                table: "Posts",
                newName: "UserId");

            migrationBuilder.RenameColumn(
                name: "IdPost",
                table: "Posts",
                newName: "PostId");

            migrationBuilder.RenameColumn(
                name: "PostIdPost",
                table: "PostLikers",
                newName: "PostId");

            migrationBuilder.RenameColumn(
                name: "IdUser",
                table: "PostLikers",
                newName: "UserId");

            migrationBuilder.RenameColumn(
                name: "IdPostLiker",
                table: "PostLikers",
                newName: "PostLikerId");

            migrationBuilder.RenameIndex(
                name: "IX_PostLikers_PostIdPost",
                table: "PostLikers",
                newName: "IX_PostLikers_PostId");

            migrationBuilder.RenameColumn(
                name: "IdPost",
                table: "Medias",
                newName: "PostId");

            migrationBuilder.RenameColumn(
                name: "IdMedia",
                table: "Medias",
                newName: "MediaId");

            migrationBuilder.RenameIndex(
                name: "IX_Medias_IdPost",
                table: "Medias",
                newName: "IX_Medias_PostId");

            migrationBuilder.RenameColumn(
                name: "IdInterest",
                table: "Interests",
                newName: "InterestId");

            migrationBuilder.RenameColumn(
                name: "PostsIdPost",
                table: "InterestPost",
                newName: "PostsPostId");

            migrationBuilder.RenameColumn(
                name: "InterestsIdInterest",
                table: "InterestPost",
                newName: "InterestsInterestId");

            migrationBuilder.RenameIndex(
                name: "IX_InterestPost_PostsIdPost",
                table: "InterestPost",
                newName: "IX_InterestPost_PostsPostId");

            migrationBuilder.RenameColumn(
                name: "IdUser",
                table: "Comments",
                newName: "UserId");

            migrationBuilder.RenameColumn(
                name: "IdPost",
                table: "Comments",
                newName: "PostId");

            migrationBuilder.RenameColumn(
                name: "IdComment",
                table: "Comments",
                newName: "CommentId");

            migrationBuilder.RenameIndex(
                name: "IX_Comments_IdPost",
                table: "Comments",
                newName: "IX_Comments_PostId");

            migrationBuilder.RenameColumn(
                name: "IdUser",
                table: "CommentLikers",
                newName: "UserId");

            migrationBuilder.RenameColumn(
                name: "CommentIdComment",
                table: "CommentLikers",
                newName: "CommentId");

            migrationBuilder.RenameColumn(
                name: "IdCommentLiker",
                table: "CommentLikers",
                newName: "CommentLikerId");

            migrationBuilder.RenameIndex(
                name: "IX_CommentLikers_CommentIdComment",
                table: "CommentLikers",
                newName: "IX_CommentLikers_CommentId");

            migrationBuilder.AlterColumn<DateTime>(
                name: "PostedAt",
                table: "Posts",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 12, 18, 34, 40, 314, DateTimeKind.Local).AddTicks(8547),
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AddColumn<DateTime>(
                name: "CommentAt",
                table: "Comments",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(2023, 10, 12, 18, 34, 40, 314, DateTimeKind.Local).AddTicks(8943));

            migrationBuilder.AddForeignKey(
                name: "FK_CommentLikers_Comments_CommentId",
                table: "CommentLikers",
                column: "CommentId",
                principalTable: "Comments",
                principalColumn: "CommentId");

            migrationBuilder.AddForeignKey(
                name: "FK_Comments_Posts_PostId",
                table: "Comments",
                column: "PostId",
                principalTable: "Posts",
                principalColumn: "PostId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_InterestPost_Interests_InterestsInterestId",
                table: "InterestPost",
                column: "InterestsInterestId",
                principalTable: "Interests",
                principalColumn: "InterestId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_InterestPost_Posts_PostsPostId",
                table: "InterestPost",
                column: "PostsPostId",
                principalTable: "Posts",
                principalColumn: "PostId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Medias_Posts_PostId",
                table: "Medias",
                column: "PostId",
                principalTable: "Posts",
                principalColumn: "PostId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_PostLikers_Posts_PostId",
                table: "PostLikers",
                column: "PostId",
                principalTable: "Posts",
                principalColumn: "PostId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CommentLikers_Comments_CommentId",
                table: "CommentLikers");

            migrationBuilder.DropForeignKey(
                name: "FK_Comments_Posts_PostId",
                table: "Comments");

            migrationBuilder.DropForeignKey(
                name: "FK_InterestPost_Interests_InterestsInterestId",
                table: "InterestPost");

            migrationBuilder.DropForeignKey(
                name: "FK_InterestPost_Posts_PostsPostId",
                table: "InterestPost");

            migrationBuilder.DropForeignKey(
                name: "FK_Medias_Posts_PostId",
                table: "Medias");

            migrationBuilder.DropForeignKey(
                name: "FK_PostLikers_Posts_PostId",
                table: "PostLikers");

            migrationBuilder.DropColumn(
                name: "CommentAt",
                table: "Comments");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "Posts",
                newName: "IdUser");

            migrationBuilder.RenameColumn(
                name: "PostId",
                table: "Posts",
                newName: "IdPost");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "PostLikers",
                newName: "IdUser");

            migrationBuilder.RenameColumn(
                name: "PostId",
                table: "PostLikers",
                newName: "PostIdPost");

            migrationBuilder.RenameColumn(
                name: "PostLikerId",
                table: "PostLikers",
                newName: "IdPostLiker");

            migrationBuilder.RenameIndex(
                name: "IX_PostLikers_PostId",
                table: "PostLikers",
                newName: "IX_PostLikers_PostIdPost");

            migrationBuilder.RenameColumn(
                name: "PostId",
                table: "Medias",
                newName: "IdPost");

            migrationBuilder.RenameColumn(
                name: "MediaId",
                table: "Medias",
                newName: "IdMedia");

            migrationBuilder.RenameIndex(
                name: "IX_Medias_PostId",
                table: "Medias",
                newName: "IX_Medias_IdPost");

            migrationBuilder.RenameColumn(
                name: "InterestId",
                table: "Interests",
                newName: "IdInterest");

            migrationBuilder.RenameColumn(
                name: "PostsPostId",
                table: "InterestPost",
                newName: "PostsIdPost");

            migrationBuilder.RenameColumn(
                name: "InterestsInterestId",
                table: "InterestPost",
                newName: "InterestsIdInterest");

            migrationBuilder.RenameIndex(
                name: "IX_InterestPost_PostsPostId",
                table: "InterestPost",
                newName: "IX_InterestPost_PostsIdPost");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "Comments",
                newName: "IdUser");

            migrationBuilder.RenameColumn(
                name: "PostId",
                table: "Comments",
                newName: "IdPost");

            migrationBuilder.RenameColumn(
                name: "CommentId",
                table: "Comments",
                newName: "IdComment");

            migrationBuilder.RenameIndex(
                name: "IX_Comments_PostId",
                table: "Comments",
                newName: "IX_Comments_IdPost");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "CommentLikers",
                newName: "IdUser");

            migrationBuilder.RenameColumn(
                name: "CommentId",
                table: "CommentLikers",
                newName: "CommentIdComment");

            migrationBuilder.RenameColumn(
                name: "CommentLikerId",
                table: "CommentLikers",
                newName: "IdCommentLiker");

            migrationBuilder.RenameIndex(
                name: "IX_CommentLikers_CommentId",
                table: "CommentLikers",
                newName: "IX_CommentLikers_CommentIdComment");

            migrationBuilder.AlterColumn<DateTime>(
                name: "PostedAt",
                table: "Posts",
                type: "datetime2",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValue: new DateTime(2023, 10, 12, 18, 34, 40, 314, DateTimeKind.Local).AddTicks(8547));

            migrationBuilder.AddForeignKey(
                name: "FK_CommentLikers_Comments_CommentIdComment",
                table: "CommentLikers",
                column: "CommentIdComment",
                principalTable: "Comments",
                principalColumn: "IdComment");

            migrationBuilder.AddForeignKey(
                name: "FK_Comments_Posts_IdPost",
                table: "Comments",
                column: "IdPost",
                principalTable: "Posts",
                principalColumn: "IdPost",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_InterestPost_Interests_InterestsIdInterest",
                table: "InterestPost",
                column: "InterestsIdInterest",
                principalTable: "Interests",
                principalColumn: "IdInterest",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_InterestPost_Posts_PostsIdPost",
                table: "InterestPost",
                column: "PostsIdPost",
                principalTable: "Posts",
                principalColumn: "IdPost",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Medias_Posts_IdPost",
                table: "Medias",
                column: "IdPost",
                principalTable: "Posts",
                principalColumn: "IdPost",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_PostLikers_Posts_PostIdPost",
                table: "PostLikers",
                column: "PostIdPost",
                principalTable: "Posts",
                principalColumn: "IdPost");
        }
    }
}
