defmodule PentoWeb.GameLive.Board do
  use PentoWeb, :live_component
  alias Pento.Game.Board
  alias Pento.Game
  import PentoWeb.GameLive.{Colors, Component}

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok,
     socket
     |> assign_params(puzzle, id)
     |> assign_board()
     |> assign_shapes()}
  end

  def assign_params(socket, puzzle, id) do
    assign(socket, %{id: id, puzzle: puzzle})
  end

  def assign_board(%{assigns: %{puzzle: puzzle}} = socket) do
    # atom must exist!
    _puzzles = Board.puzzles()

    board =
      puzzle
      |> String.to_existing_atom()
      |> Board.new()

    assign(socket, board: board)
  end

  def assign_shapes(%{assigns: %{board: board}} = socket) do
    shapes = Board.to_shapes(board)
    assign(socket, shapes: shapes)
  end
end
