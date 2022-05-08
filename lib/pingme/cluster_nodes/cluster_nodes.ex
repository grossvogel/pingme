defmodule Pingme.ClusterNodes do
  @moduledoc """
  Logic for collecting and manipulating info about nodes in the cluster
  """
  alias Pingme.ClusterNode

  @spec ping_nodes() :: list(ClusterNode.t())
  def ping_nodes() do
    Enum.map(Node.list(), fn node_name ->
      %ClusterNode{name: node_name, pings: [], average_ping: 0}
    end)
  end

  def self() do
    Node.self()
  end
end
