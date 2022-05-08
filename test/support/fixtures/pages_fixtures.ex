defmodule Pingme.PagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pingme.Pages` context.
  """

  @doc """
  Generate a home.
  """
  def home_fixture(attrs \\ %{}) do
    {:ok, home} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Pingme.Pages.create_home()

    home
  end
end
