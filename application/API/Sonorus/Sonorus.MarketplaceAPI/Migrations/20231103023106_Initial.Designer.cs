﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Sonorus.MarketplaceAPI.Data.Context;

#nullable disable

namespace Sonorus.MarketplaceAPI.Migrations
{
    [DbContext(typeof(MarketplaceAPIDbContext))]
    [Migration("20231103023106_Initial")]
    partial class Initial
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.8")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("Sonorus.MarketplaceAPI.Data.Entities.Media", b =>
                {
                    b.Property<long?>("MediaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<long?>("MediaId"));

                    b.Property<string>("Path")
                        .IsRequired()
                        .HasMaxLength(41)
                        .HasColumnType("nvarchar(41)");

                    b.Property<long>("ProductId")
                        .HasColumnType("bigint");

                    b.HasKey("MediaId");

                    b.HasIndex("ProductId");

                    b.ToTable("Medias");
                });

            modelBuilder.Entity("Sonorus.MarketplaceAPI.Data.Entities.Product", b =>
                {
                    b.Property<long>("ProductId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<long>("ProductId"));

                    b.Property<DateTime>("AnnouncedAt")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("datetime2")
                        .HasDefaultValue(new DateTime(2023, 11, 2, 23, 31, 6, 298, DateTimeKind.Local).AddTicks(4258));

                    b.Property<decimal>("Price")
                        .HasColumnType("decimal(18,2)");

                    b.Property<long>("SellerId")
                        .HasColumnType("bigint");

                    b.HasKey("ProductId");

                    b.ToTable("Products");
                });

            modelBuilder.Entity("Sonorus.MarketplaceAPI.Data.Entities.Media", b =>
                {
                    b.HasOne("Sonorus.MarketplaceAPI.Data.Entities.Product", "Product")
                        .WithMany("Medias")
                        .HasForeignKey("ProductId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Product");
                });

            modelBuilder.Entity("Sonorus.MarketplaceAPI.Data.Entities.Product", b =>
                {
                    b.Navigation("Medias");
                });
#pragma warning restore 612, 618
        }
    }
}
