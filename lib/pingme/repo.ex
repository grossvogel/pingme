defmodule Pingme.Repo do
  use Ecto.Repo,
    otp_app: :pingme,
    adapter: Ecto.Adapters.Postgres
end
