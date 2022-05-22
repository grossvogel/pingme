defmodule Pingme.ClusterNode do
  @moduledoc """
  Info about a node in the cluster
  """
  defstruct(
    name: nil,
    last_ping_ms: nil,
    max_ping_ms: -1,
    min_ping_ms: 100_000_000,
    total_ping_ms: 0,
    sum_of_squares: 0,
    ping_count: 0,
    ping_history: nil,
    region: "local"
  )

  @type t() :: %__MODULE__{}
end
