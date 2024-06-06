defmodule Pento.Game.Point do
  @upper_bound 6

  def new(x, y)
      when is_integer(x) and is_integer(y) do
    {x, y}
  end

  def move({x, y}, {dx, dy}) do
    {x + dx, y + dy}
  end

  def up(point, dy \\ 1) do
    move(point, {0, dy})
  end

  def down(point, dy \\ 1) do
    move(point, {0, -dy})
  end

  def right(point, dx \\ 1) do
    move(point, {dx, 0})
  end

  def left(point, dx \\ 1) do
    move(point, {-dx, 0})
  end

  @doc """
  \***
  *\ *
  * \*
  ***\
  """
  def transpose({x, y}) do
    {y, x}
  end

  @doc """
  *
  *
  ***
  ---
  ***
  *
  *
  """
  def flip({x, y}) do
    {x, @upper_bound - y}
  end

  @doc """
  *  |  *
  *  |  *
  ***|***
  """
  def reflect({x, y}) do
    {@upper_bound - x, y}
  end

  def rotate(point, 0), do: point
  def rotate(point, 90), do: point |> reflect |> transpose
  def rotate(point, 180), do: point |> reflect |> flip
  def rotate(point, 270), do: point |> flip |> transpose

  def center(point) do
    move(point, {-3, -3})
  end

  def prepare(point, rotation, reflected, location) do
    point
    |> rotate(rotation)
    |> maybe_reflect(reflected)
    |> move(location)
    |> center()
  end

  def maybe_reflect(point, true), do: reflect(point)
  def maybe_reflect(point, false), do: point
end
