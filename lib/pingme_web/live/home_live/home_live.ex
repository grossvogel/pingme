defmodule PingmeWeb.HomeLive do
  use PingmeWeb, :live_view
  alias Pingme.ClusterNodes

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:self, ClusterNodes.self())
      |> assign(:peers, ClusterNodes.ping_nodes())

    {:ok, socket}
  end
end
