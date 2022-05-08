defmodule PingmeWeb.HomeLiveTest do
  use PingmeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pingme.PagesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_home(_) do
    home = home_fixture()
    %{home: home}
  end

  describe "Index" do
    setup [:create_home]

    test "lists all home", %{conn: conn, home: home} do
      {:ok, _index_live, html} = live(conn, Routes.home_index_path(conn, :index))

      assert html =~ "Listing Home"
      assert html =~ home.name
    end

    test "saves new home", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.home_index_path(conn, :index))

      assert index_live |> element("a", "New Home") |> render_click() =~
               "New Home"

      assert_patch(index_live, Routes.home_index_path(conn, :new))

      assert index_live
             |> form("#home-form", home: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#home-form", home: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.home_index_path(conn, :index))

      assert html =~ "Home created successfully"
      assert html =~ "some name"
    end

    test "updates home in listing", %{conn: conn, home: home} do
      {:ok, index_live, _html} = live(conn, Routes.home_index_path(conn, :index))

      assert index_live |> element("#home-#{home.id} a", "Edit") |> render_click() =~
               "Edit Home"

      assert_patch(index_live, Routes.home_index_path(conn, :edit, home))

      assert index_live
             |> form("#home-form", home: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#home-form", home: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.home_index_path(conn, :index))

      assert html =~ "Home updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes home in listing", %{conn: conn, home: home} do
      {:ok, index_live, _html} = live(conn, Routes.home_index_path(conn, :index))

      assert index_live |> element("#home-#{home.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#home-#{home.id}")
    end
  end

  describe "Show" do
    setup [:create_home]

    test "displays home", %{conn: conn, home: home} do
      {:ok, _show_live, html} = live(conn, Routes.home_show_path(conn, :show, home))

      assert html =~ "Show Home"
      assert html =~ home.name
    end

    test "updates home within modal", %{conn: conn, home: home} do
      {:ok, show_live, _html} = live(conn, Routes.home_show_path(conn, :show, home))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Home"

      assert_patch(show_live, Routes.home_show_path(conn, :edit, home))

      assert show_live
             |> form("#home-form", home: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#home-form", home: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.home_show_path(conn, :show, home))

      assert html =~ "Home updated successfully"
      assert html =~ "some updated name"
    end
  end
end
