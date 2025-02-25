defmodule Pingme.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Pingme.Repo,
      # Start the Telemetry supervisor
      PingmeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pingme.PubSub},
      # Start the Endpoint (http/https)
      PingmeWeb.Endpoint,
      # Start a worker by calling: Pingme.Worker.start_link(arg)
      # {Pingme.Worker, arg}
      Pingme.Heartbeat,
      {Cluster.Supervisor, [cluster_topologies(), [name: Pingme.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pingme.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PingmeWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp cluster_topologies(), do: Application.get_env(:libcluster, :topologies)
end
