defmodule Pingme.ClusterNode do
  @moduledoc """
  Info about a node in the cluster
  """
  defstruct([:name, :pings, :average_ping])

  @type t() :: %__MODULE__{}
end
