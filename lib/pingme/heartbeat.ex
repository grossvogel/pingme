defmodule Pingme.Heartbeat do
  @moduledoc """
  Ping other nodes in the cluster periodically
  """
  use GenServer
  alias Pingme.ClusterNodes
  require Logger

  @default_state %{
    ping_interval_seconds: 5,
    nodes: []
  }

  def start_link(opts) do
    GenServer.start_link(__MODULE__, Keyword.put(opts, :name, __MODULE__))
  end

  def set_interval(new_interval) when is_integer(new_interval) do
    GenServer.cast(__MODULE__, {:set_interval, new_interval})
  end

  @impl GenServer
  def init(_opts) do
    state = @default_state
    Process.send_after(self(), :ping_nodes, state.ping_interval_seconds * 1000)
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:ping, _from, state) do
    {:reply, :pong, state}
  end

  @impl GenServer
  def handle_cast({:set_interval, new_interval}, state) when is_integer(new_interval) do
    {:noreply, Map.put(state, :ping_interval_seconds, new_interval)}
  end

  @impl GenServer
  def handle_info(:ping_nodes, state) do
    Logger.info("here is where we ping other nodes: #{inspect(state)}")
    next_state = Map.put(state, :nodes, ClusterNodes.ping_nodes())
    Process.send_after(self(), :ping_nodes, next_state.ping_interval_seconds * 1000)
    {:noreply, next_state}
  end
end
