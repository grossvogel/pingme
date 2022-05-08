defmodule PingmeWeb.HomeLive do
  use PingmeWeb, :live_view
  alias Pingme.{Heartbeat, ClusterNodes}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:self, ClusterNodes.self())
      |> assign(:peers, Map.values(Heartbeat.get_nodes()))
      |> assign(:ping_interval, Heartbeat.ping_interval())

    {:ok, socket}
  end
end
