defmodule Pingme.ClusterNodes do
  @moduledoc """
  Logic for collecting and manipulating info about nodes in the cluster
  """
  alias Pingme.{ClusterNode, RingBuffer}

  # store 3 hours worth of pings by default (at 5s interval)
  @ping_history_size round(60 / 5 * 60 * 3)

  def self() do
    Node.self()
  end

  def region() do
    Application.get_env(:pingme, :region, "local")
  end

  def new(name, nil) when is_atom(name), do: new(name, "Unknown")

  def new(name, region) when is_atom(name) and is_binary(region) do
    %ClusterNode{name: name, region: region, ping_history: RingBuffer.new(@ping_history_size)}
  end

  # https://math.stackexchange.com/a/102982
  # using population std dev for simplicity / efficiency since we'll have a lot of samples
  def std_deviation(%ClusterNode{
        ping_count: count,
        total_ping_ms: sum,
        sum_of_squares: sum_of_squares
      }) do
    :math.sqrt(count * sum_of_squares - sum * sum) / count
  end

  def record_ping(%ClusterNode{} = node, ms_elapsed) do
    %{
      node
      | last_ping_ms: ms_elapsed,
        ping_count: node.ping_count + 1,
        total_ping_ms: node.total_ping_ms + ms_elapsed,
        sum_of_squares: node.sum_of_squares + ms_elapsed * ms_elapsed,
        max_ping_ms: max(node.max_ping_ms, ms_elapsed),
        min_ping_ms: min(node.min_ping_ms, ms_elapsed),
        ping_history: RingBuffer.add(node.ping_history, ms_elapsed)
    }
  end
end
