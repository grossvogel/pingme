defmodule Pingme.ClusterNodes do
  @moduledoc """
  Logic for collecting and manipulating info about nodes in the cluster
  """
  alias Pingme.ClusterNode

  def self() do
    Node.self()
  end
end
