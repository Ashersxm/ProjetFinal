﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;
using data.Models.EntityFramework;

#nullable disable

namespace data.Migrations
{
    [DbContext(typeof(EventDBContext))]
    [Migration("20241230170708_CreationBDSeries")]
    partial class CreationBDSeries
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasDefaultSchema("public")
                .HasAnnotation("ProductVersion", "8.0.4")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("data.Models.EntityFramework.Events", b =>
                {
                    b.Property<int>("IdEvent")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("evt_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("IdEvent"));

                    b.Property<string>("EventDescription")
                        .HasMaxLength(500)
                        .HasColumnType("character varying(500)")
                        .HasColumnName("evt_description");

                    b.Property<string>("EventName")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("character varying(50)")
                        .HasColumnName("evt_name");

                    b.Property<int>("IdGenre")
                        .HasColumnType("integer")
                        .HasColumnName("gen_id");

                    b.HasKey("IdEvent");

                    b.HasIndex("IdEvent");

                    b.HasIndex("IdGenre");

                    b.ToTable("t_e_events_utl", "public");
                });

            modelBuilder.Entity("data.Models.EntityFramework.EventsInvite", b =>
                {
                    b.Property<int>("idEventsInvite")
                        .HasColumnType("integer")
                        .HasColumnName("ein_id");

                    b.Property<int>("IdEvent")
                        .HasColumnType("integer")
                        .HasColumnName("evt_id");

                    b.Property<int>("IdUser")
                        .HasColumnType("integer")
                        .HasColumnName("usr_id");

                    b.Property<bool>("IsPending")
                        .HasColumnType("boolean")
                        .HasColumnName("ein_state");

                    b.HasKey("idEventsInvite", "IdEvent", "IdUser");

                    b.HasIndex("IdEvent");

                    b.HasIndex("IdUser");

                    b.HasIndex("idEventsInvite");

                    b.ToTable("t_e_eventsinvite_utl", "public");
                });

            modelBuilder.Entity("data.Models.EntityFramework.Genres", b =>
                {
                    b.Property<int>("IdGenre")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("gen_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("IdGenre"));

                    b.Property<string>("GenreName")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("gen_name");

                    b.HasKey("IdGenre");

                    b.ToTable("t_e_genres_utl", "public");
                });

            modelBuilder.Entity("data.Models.EntityFramework.Users", b =>
                {
                    b.Property<int>("IdUser")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("usr_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("IdUser"));

                    b.Property<DateTime>("DateCreation")
                        .HasColumnType("timestamp with time zone")
                        .HasColumnName("usr_datecreation");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("character varying(100)")
                        .HasColumnName("usr_email");

                    b.Property<string>("FirstName")
                        .HasColumnType("text")
                        .HasColumnName("usr_firstname");

                    b.Property<string>("LastName")
                        .HasColumnType("text")
                        .HasColumnName("usr_lastname");

                    b.Property<string>("Password")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("usr_password");

                    b.Property<string>("UserName")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("usr_nametag");

                    b.HasKey("IdUser");

                    b.HasIndex("Email")
                        .IsUnique();

                    b.ToTable("t_e_users_utl", "public");
                });

            modelBuilder.Entity("data.Models.EntityFramework.Events", b =>
                {
                    b.HasOne("data.Models.EntityFramework.Genres", "GenreEvent")
                        .WithMany("EventsGenre")
                        .HasForeignKey("IdGenre")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired()
                        .HasConstraintName("fk_genre_events");

                    b.Navigation("GenreEvent");
                });

            modelBuilder.Entity("data.Models.EntityFramework.EventsInvite", b =>
                {
                    b.HasOne("data.Models.EntityFramework.Events", "EventReference")
                        .WithMany("EventInvitation")
                        .HasForeignKey("IdEvent")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired()
                        .HasConstraintName("fk_event_invitation");

                    b.HasOne("data.Models.EntityFramework.Users", "UserReference")
                        .WithMany("UserInvitation")
                        .HasForeignKey("IdUser")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired()
                        .HasConstraintName("fk_users_invitation");

                    b.Navigation("EventReference");

                    b.Navigation("UserReference");
                });

            modelBuilder.Entity("data.Models.EntityFramework.Events", b =>
                {
                    b.Navigation("EventInvitation");
                });

            modelBuilder.Entity("data.Models.EntityFramework.Genres", b =>
                {
                    b.Navigation("EventsGenre");
                });

            modelBuilder.Entity("data.Models.EntityFramework.Users", b =>
                {
                    b.Navigation("UserInvitation");
                });
#pragma warning restore 612, 618
        }
    }
}
