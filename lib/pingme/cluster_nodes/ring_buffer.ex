defmodule Pingme.RingBuffer do
  @moduledoc """
  Stores a limited-size list of past measurements
  """
  defstruct [:items, :max_size, :size]

  @type t() :: %__MODULE__{}

  @doc """
  Create an empty ring buffer with the specified max size

  ## Examples

      iex> 5 |> RingBuffer.new() |> RingBuffer.max_size()
      5

      iex> 5 |> RingBuffer.new() |> RingBuffer.add(5) |> RingBuffer.add(2) |> RingBuffer.size()
      2

      iex> 5 |> RingBuffer.new() |> RingBuffer.add(5) |> RingBuffer.add(2) |> RingBuffer.to_list()
      [5, 2]

      iex> 5 |> RingBuffer.new() |> RingBuffer.add(5) |> RingBuffer.add(2) |> RingBuffer.full?()
      false

      iex> 2 |> RingBuffer.new() |> RingBuffer.add(5) |> RingBuffer.add(2) |> RingBuffer.full?()
      true

      iex> 2 |> RingBuffer.new() |> RingBuffer.add(5) |> RingBuffer.add(2) |> RingBuffer.add(3) |> RingBuffer.to_list()
      [2, 3]
  """
  def new(max_size) when is_integer(max_size) and max_size >= 1 do
    %__MODULE__{items: :queue.new(), size: 0, max_size: max_size}
  end

  def full?(%__MODULE__{size: size, max_size: max_size}) when max_size > size, do: false

  def full?(%__MODULE__{}), do: true

  def size(%__MODULE__{size: size}), do: size

  def max_size(%__MODULE__{max_size: max_size}), do: max_size

  def to_list(%__MODULE__{items: items}), do: :queue.to_list(items)

  def add(%__MODULE__{size: size, max_size: max_size} = buffer, new_item) when size >= max_size do
    buffer
    |> evict_first()
    |> add(new_item)
  end

  def add(%__MODULE__{items: items, size: size} = buffer, new_item) do
    %{buffer | items: :queue.in(new_item, items), size: size + 1}
  end

  defp evict_first(%__MODULE__{size: 0}) do
    raise ArgumentError, message: "Buffer is empty, cannot evict the first item"
  end

  defp evict_first(%__MODULE__{items: items, size: size} = buffer) do
    {_, new_items} = :queue.out(items)
    %{buffer | items: new_items, size: size - 1}
  end
end
