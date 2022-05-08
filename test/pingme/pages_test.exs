defmodule Pingme.PagesTest do
  use Pingme.DataCase

  alias Pingme.Pages

  describe "home" do
    alias Pingme.Pages.Home

    import Pingme.PagesFixtures

    @invalid_attrs %{name: nil}

    test "list_home/0 returns all home" do
      home = home_fixture()
      assert Pages.list_home() == [home]
    end

    test "get_home!/1 returns the home with given id" do
      home = home_fixture()
      assert Pages.get_home!(home.id) == home
    end

    test "create_home/1 with valid data creates a home" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Home{} = home} = Pages.create_home(valid_attrs)
      assert home.name == "some name"
    end

    test "create_home/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pages.create_home(@invalid_attrs)
    end

    test "update_home/2 with valid data updates the home" do
      home = home_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Home{} = home} = Pages.update_home(home, update_attrs)
      assert home.name == "some updated name"
    end

    test "update_home/2 with invalid data returns error changeset" do
      home = home_fixture()
      assert {:error, %Ecto.Changeset{}} = Pages.update_home(home, @invalid_attrs)
      assert home == Pages.get_home!(home.id)
    end

    test "delete_home/1 deletes the home" do
      home = home_fixture()
      assert {:ok, %Home{}} = Pages.delete_home(home)
      assert_raise Ecto.NoResultsError, fn -> Pages.get_home!(home.id) end
    end

    test "change_home/1 returns a home changeset" do
      home = home_fixture()
      assert %Ecto.Changeset{} = Pages.change_home(home)
    end
  end
end
