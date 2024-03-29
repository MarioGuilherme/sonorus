﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Sonorus.AccountAPI.Data.Context;

#nullable disable

namespace Sonorus.AccountAPI.Migrations
{
    [DbContext(typeof(AccountAPIDbContext))]
    [Migration("20230820044944_TableOfUsersInterests")]
    partial class TableOfUsersInterests
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.8")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("Sonorus.AccountAPI.Models.Interest", b =>
                {
                    b.Property<long?>("IdInterest")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<long?>("IdInterest"));

                    b.Property<string>("Key")
                        .IsRequired()
                        .HasMaxLength(60)
                        .HasColumnType("nvarchar(60)");

                    b.Property<int>("Type")
                        .HasColumnType("int");

                    b.Property<long?>("UserIdUser")
                        .HasColumnType("bigint");

                    b.Property<string>("Value")
                        .IsRequired()
                        .HasMaxLength(60)
                        .HasColumnType("nvarchar(60)");

                    b.HasKey("IdInterest");

                    b.HasIndex("Key")
                        .IsUnique();

                    b.HasIndex("UserIdUser");

                    b.ToTable("Interests");
                });

            modelBuilder.Entity("Sonorus.AccountAPI.Models.User", b =>
                {
                    b.Property<long?>("IdUser")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<long?>("IdUser"));

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<string>("Fullname")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<string>("Nickname")
                        .IsRequired()
                        .HasMaxLength(25)
                        .HasColumnType("nvarchar(25)");

                    b.Property<string>("Password")
                        .IsRequired()
                        .HasMaxLength(60)
                        .HasColumnType("nvarchar(60)");

                    b.HasKey("IdUser");

                    b.HasIndex("Email")
                        .IsUnique();

                    b.HasIndex("Nickname")
                        .IsUnique();

                    b.ToTable("Users");
                });

            modelBuilder.Entity("Sonorus.AccountAPI.Models.UserInterest", b =>
                {
                    b.Property<long?>("IdUserInterest")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<long?>("IdUserInterest"));

                    b.Property<long?>("IdInterest")
                        .HasColumnType("bigint");

                    b.Property<long?>("IdUser")
                        .HasColumnType("bigint");

                    b.Property<long>("InterestIdInterest")
                        .HasColumnType("bigint");

                    b.Property<long>("UserIdUser")
                        .HasColumnType("bigint");

                    b.HasKey("IdUserInterest");

                    b.HasIndex("InterestIdInterest");

                    b.HasIndex("UserIdUser");

                    b.ToTable("UsersInterests");
                });

            modelBuilder.Entity("Sonorus.AccountAPI.Models.Interest", b =>
                {
                    b.HasOne("Sonorus.AccountAPI.Models.User", null)
                        .WithMany("Interests")
                        .HasForeignKey("UserIdUser");
                });

            modelBuilder.Entity("Sonorus.AccountAPI.Models.UserInterest", b =>
                {
                    b.HasOne("Sonorus.AccountAPI.Models.Interest", "Interest")
                        .WithMany()
                        .HasForeignKey("InterestIdInterest")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("Sonorus.AccountAPI.Models.User", "User")
                        .WithMany()
                        .HasForeignKey("UserIdUser")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Interest");

                    b.Navigation("User");
                });

            modelBuilder.Entity("Sonorus.AccountAPI.Models.User", b =>
                {
                    b.Navigation("Interests");
                });
#pragma warning restore 612, 618
        }
    }
}
