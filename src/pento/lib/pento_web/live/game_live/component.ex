defmodule PentoWeb.GameLive.Component do
  use Phoenix.Component
  alias Pento.Game.Pentomino
  import PentoWeb.GameLive.Colors

  @width 10

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :fill, :string
  attr :name, :string
  attr :"phx-click", :string
  attr :"phx-value", :string
  attr :"phx-target", :any

  def point(assigns) do
    ~H"""
    <use
      xlink:href="#point"
      x={convert(@x)}
      y={convert(@y)}
      fill={@fill}
      phx-click="pick"
      phx-value-name={@name}
      phx-target="#game"
    />
    """
  end

  defp convert(i)
       when is_integer(i) do
    (i - 1) * @width + 2 * @width
  end

  attr :points, :list, required: true
  attr :name, :string, required: true
  attr :fill, :string, required: true

  def shape(assigns) do
    ~H"""
    <%= for {x, y} <- @points do %>
      <.point x={x} y={y} fill={@fill} name={@name} />
    <% end %>
    """
  end

  attr :viewBox, :string
  slot :inner_block, required: true

  def canvas(assigns) do
    ~H"""
    <svg viewBox={@viewBox}>
      <defs>
        <rect id="point" width="10" height="10" />
      </defs>
      <%= render_slot(@inner_block) %>
    </svg>
    """
  end

  attr :shape_names, :list, required: true
  attr :completed_shape_names, :list, default: []

  def palette(assigns) do
    ~H"""
    <div id="palette">
      <.canvas viewBox="0 0 500 125">
        <%= for shape <- palette_shapes(@shape_names) do %>
          <.shape
            points={shape.points}
            fill={color(shape.color, false, shape.name in @completed_shape_names)}
            name={shape.name}
          />
        <% end %>
      </.canvas>
    </div>
    """
  end

  defp palette_shapes(names) do
    names
    |> Enum.with_index()
    |> Enum.map(&place_pento/1)
  end

  defp place_pento({name, i}) do
    Pentomino.new(name: name, location: location(i)) |> Pentomino.to_shape()
  end

  defp location(i) do
    x = rem(i, 6) * 4 + 3
    y = div(i, 6) * 5 + 3
    {x, y}
  end

  attr :width, :integer
  def control_panel(assigns) do
    ~H"""
    <svg viewBox="0 0 40 40" width={@width}>
      <defs>
        <polygon id="triangle" points="6.25 1.875, 12.5 12.5, 0 12.5" />
      </defs>

      <.triangle rotate={0} x={14} y={0} fill={color(:light_blue)} />
      <.triangle rotate={90} x={14} y={0} fill={color(:light_blue)} />
      <.triangle rotate={180} x={14} y={0} fill={color(:light_blue)} />
      <.triangle rotate={270} x={14} y={0} fill={color(:light_blue)} />
      <circle cx="20" cy="20" r="1" />
    </svg>
    """
  end

  attr :rotate, :integer
  attr :x, :integer
  attr :y, :integer
  attr :fill, :string
  def triangle(assigns) do
    ~H"""
    <use x={@x} y={@y} transform={rotate(@rotate, 20, 20)} href="#triangle" fill={@fill} />
    """
  end

  defp rotate(rotation, x, y) do
    "rotate(#{rotation}, #{x}, #{y})"
  end
end
