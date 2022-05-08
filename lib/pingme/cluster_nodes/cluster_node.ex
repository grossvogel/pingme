defmodule Pingme.ClusterNode do
  @moduledoc """
  Info about a node in the cluster
  """
  defstruct(name: nil, last_ping_ms: nil, ping_count: 0, region: "local")

  @type t() :: %__MODULE__{}
end
