defmodule Pento.Game.Pentomino do
  alias Pento.Game.Point
  alias Pento.Game.Shape
  @names [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  @default_location {8, 8}
  defstruct name: :i, rotation: 0, reflected: false, location: @default_location

  def new(fields \\ []) do
    pento = __struct__(fields)
    if pento.name not in @names do
      raise "name not in #{@names}"
    else
      pento
    end
  end

  def rotate(%__MODULE__{rotation: degrees} = p) do
    %{p | rotation: rem(degrees + 90, 360)}
  end

  def flip(%__MODULE__{reflected: reflection} = p) do
    %{p | reflected: not reflection}
  end

  def up(%__MODULE__{} = p) do
    %{p | location: Point.up(p.location)}
  end

  def down(%__MODULE__{} = p) do
    %{p | location: Point.down(p.location)}
  end

  def left(%__MODULE__{} = p) do
    %{p | location: Point.left(p.location)}
  end

  def right(%__MODULE__{} = p) do
    %{p | location: Point.right(p.location)}
  end

  def rename(%__MODULE__{} = p, name)
      when name in @names do
    %{p | name: name}
  end

  def to_shape(%__MODULE__{} = pento) do
    Shape.new(pento.name, pento.rotation, pento.reflected, pento.location)
  end

  def overlapping?(pento1, pento2) do
    {p1, p2} = {to_shape(pento1).points, to_shape(pento2).points}
    Enum.count(p1 -- p2) != 5
  end
end
