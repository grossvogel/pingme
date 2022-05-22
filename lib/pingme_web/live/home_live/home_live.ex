defmodule PingmeWeb.HomeLive do
  use PingmeWeb, :live_view
  alias Pingme.{Heartbeat, ClusterNodes}
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    :ok = PingmeWeb.Endpoint.subscribe("node_updated", [])

    socket =
      socket
      |> assign(:self, ClusterNodes.self())
      |> assign(:peers, Map.values(Heartbeat.get_nodes()))
      |> assign(:ping_interval, Heartbeat.ping_interval())
      |> assign(:region, ClusterNodes.region())

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(%{topic: "node_updated", event: "pong", payload: payload}, socket) do
    {:noreply,
     socket
     |> assign(:peers, Map.values(Heartbeat.get_nodes()))
     |> push_event("node_pong", payload)}
  end

  @impl Phoenix.LiveView
  def handle_info(args, socket) do
    Logger.warning("Received unexpected message: #{inspect(args)}")
    {:noreply, socket}
  end
end
