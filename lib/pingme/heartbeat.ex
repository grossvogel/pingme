defmodule Pingme.Heartbeat do
  @moduledoc """
  Ping other nodes in the cluster periodically
  """
  use GenServer
  alias Pingme.{ClusterNode, ClusterNodes}
  require Logger

  @default_state %{
    ping_interval_seconds: 5,
    nodes: %{}
  }

  def start_link(opts) do
    {ok, pid} = GenServer.start_link(__MODULE__, opts, name: __MODULE__)
    Logger.info("#{__MODULE__} started with pid #{inspect(pid)}")
    {ok, pid}
  end

  def set_interval(new_interval) when is_integer(new_interval) do
    GenServer.cast(__MODULE__, {:set_interval, new_interval})
  end

  def ping_interval() do
    GenServer.call(__MODULE__, :get_interval)
  end

  def get_nodes() do
    GenServer.call(__MODULE__, :get_nodes)
  end

  @impl GenServer
  def init(_opts) do
    state = @default_state
    Process.send_after(self(), :ping_nodes, state.ping_interval_seconds * 1000)
    {:ok, state}
  end

  @impl GenServer
  def handle_info({:ping, from_node, start_ts}, state) do
    Process.send(
      {__MODULE__, from_node},
      {:pong, ClusterNodes.self(), ClusterNodes.region(), start_ts},
      []
    )

    {:noreply, state}
  end

  def handle_info({:pong, from_node, node_region, start_ts}, %{nodes: nodes} = state) do
    ms_elapsed = current_ts() - start_ts
    node = Map.get(nodes, from_node, %ClusterNode{name: from_node})

    next_nodes =
      Map.put(nodes, from_node, %{
        node
        | last_ping_ms: ms_elapsed,
          ping_count: node.ping_count + 1,
          region: node_region
      })

    next_state = Map.put(state, :nodes, next_nodes)
    Logger.info("Received ping from #{from_node} after #{ms_elapsed}ms: #{inspect(next_state)}")

    PingmeWeb.Endpoint.local_broadcast(
      "node_updated",
      "pong",
      %{:nodes => next_nodes}
    )

    {:noreply, next_state}
  end

  @impl GenServer
  def handle_info(:ping_nodes, state) do
    start_ts = current_ts()

    Enum.each(
      Node.list(),
      fn node -> Process.send({__MODULE__, node}, {:ping, ClusterNodes.self(), start_ts}, []) end
    )

    Process.send_after(self(), :ping_nodes, state.ping_interval_seconds * 1000)
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:get_nodes, _from, state) do
    {:reply, state.nodes, state}
  end

  @impl GenServer
  def handle_call(:get_interval, _from, state) do
    {:reply, state.ping_interval_seconds, state}
  end

  @impl GenServer
  def handle_cast({:set_interval, new_interval}, state) when is_integer(new_interval) do
    Logger.info("ping interval is now #{new_interval}")
    {:noreply, Map.put(state, :ping_interval_seconds, new_interval)}
  end

  defp current_ts() do
    "Etc/UTC"
    |> DateTime.now!()
    |> DateTime.to_unix(:millisecond)
  end
end
