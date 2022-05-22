defmodule PingmeWeb.HomeLiveTest do
  use PingmeWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Home" do
    test "shows the page", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.live_path(conn, PingmeWeb.HomeLive))

      assert html =~ "Ping Interval"
    end
  end
end
