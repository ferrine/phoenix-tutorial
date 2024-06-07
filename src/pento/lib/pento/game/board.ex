defmodule Pento.Game.Board do
  alias Pento.Game.{Pentomino, Shape}
  defstruct active_pento: nil, completed_pentos: [], palette: [], points: []

  def puzzles(), do: ~w[default wide widest medium tiny]a

  def new(palette, points) do
    %__MODULE__{palette: palette(palette), points: points}
  end

  def new(name)
      when is_binary(name) do
    # atom must exist!
    _ = puzzles()
    new(String.to_existing_atom(name))
  end

  def new(:tiny), do: new(:small, rect(5, 3))
  def new(:widest), do: new(:all, rect(20, 3))
  def new(:wide), do: new(:all, rect(15, 4))
  def new(:medium), do: new(:all, rect(12, 5))
  def new(:default), do: new(:all, rect(10, 6))

  defp rect(x, y) do
    for x <- 1..x, y <- 1..y, do: {x, y}
  end

  defp palette(:all), do: [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  defp palette(:small), do: [:u, :v, :p]

  def to_shape(board) do
    Shape.__struct__(color: :purple, name: :board, points: board.points)
  end

  def to_shapes(board) do
    board_shape = to_shape(board)

    pento_shapes =
      [board.active_pento | board.completed_pentos]
      |> Enum.reverse()
      # active pento can be nil, filter that
      |> Enum.filter(& &1)
      |> Enum.map(&Pentomino.to_shape/1)

    [board_shape | pento_shapes]
  end

  def active?(board, shape_name) when is_binary(shape_name) do
    active?(board, String.to_existing_atom(shape_name))
  end

  def active?(%{active_pento: %{name: shape_name}}, shape_name) do
    true
  end

  def active?(_board, _shape_name) do
    false
  end

  def pick(board, sname)
      when is_binary(sname) do
    sname = String.to_existing_atom(sname)
    pick(board, sname)
  end
  # Let’s start with the first scenario: ignoring the action if
  # the selected shape name is :board.
  def pick(board, :board), do: board
  # Next up, we’ll handle the second scenario. The user is clicking on a
  # pentomino, but an active pentomino is already selected. In that
  # case, if the user clicks on the active one, we want to release it.
  def pick(%{active_pento: pento} = board, sname) when not is_nil(pento) do
    if pento.name == sname do
      %{board | active_pento: nil}
    else
      board
    end
  end

  # last scenario: there is no active pento, and the shape is not the
  # underlying :board. That means the user is picking up a
  # pentomino. It might be one that has already been solved. If so,
  # we’ll remove it from the completed list and let them place it
  # again. If not, we’ll simply make it the active pentomino.
  def pick(board, shape_name) do
    active =
      board.completed_pentos
      |> Enum.find(&(&1.name == shape_name))
      |> Kernel.||(new_pento(board, shape_name))

    completed = Enum.filter(board.completed_pentos, &(&1.name != shape_name))
    %{board | active_pento: active, completed_pentos: completed}
  end

  defp new_pento(board, shape_name) do
    Pentomino.new(name: shape_name, location: midpoints(board))
  end

  defp midpoints(board) do
    {xs, ys} = Enum.unzip(board.points)
    {midpoint(xs), midpoint(ys)}
  end

  defp midpoint(i), do: round(Enum.max(i) / 2.0)

  def drop(%{active_pento: nil} = board), do: board

  def drop(%{active_pento: pento} = board) do
    board
    |> Map.put(:active_pento, nil)
    |> Map.put(:completed_pentos, [pento | board.completed_pentos])
  end

  def legal_drop?(%{active_pento: pento}) when is_nil(pento), do: false

  def legal_drop?(%{active_pento: pento, points: board_points} = board) do
    points_on_board =
      Pentomino.to_shape(pento).points
      |> Enum.all?(
        fn point -> point in board_points end)

    no_overlapping_pentos = !Enum.any?(board.completed_pentos, &Pentomino.overlapping?(pento, &1))
    points_on_board and no_overlapping_pentos
  end

  def legal_move?(%{active_pento: pento, points: points}=_board) do
    pento.location in points
  end
end
