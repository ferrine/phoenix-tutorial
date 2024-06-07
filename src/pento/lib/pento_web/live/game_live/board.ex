defmodule PentoWeb.GameLive.Board do
  use PentoWeb, :live_component
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
    board =
      puzzle
      |> Game.new_game()

    assign(socket, board: board)
  end

  def assign_shapes(%{assigns: %{board: board}} = socket) do
    shapes = Game.to_shapes(board)
    assign(socket, shapes: shapes)
  end

  def handle_event("pick", %{"name" => name}, socket) do
    {:noreply, socket |> pick(name) |> assign_shapes}
  end

  def handle_event("key", %{"key" => key}, socket) do
    {:noreply, socket |> do_key(key) |> assign_shapes}
  end

  def do_key(socket, key) do
    case key do
      " " -> drop(socket)
      "ArrowLeft" -> move(socket, :left)
      "ArrowRight" -> move(socket, :right)
      "ArrowUp" -> move(socket, :up)
      "ArrowDown" -> move(socket, :down)
      "Shift" -> move(socket, :rotate)
      "Enter" -> move(socket, :flip)
      "Space" -> drop(socket)
      _ -> socket
    end
  end

  def move(socket, move) do
    case Game.maybe_move(socket.assigns.board, move) do
      {:error, message} -> put_flash(socket, :info, message)
      {:ok, board} -> socket |> assign(board: board) |> assign_shapes
    end
  end

  defp drop(socket) do
    case Game.maybe_drop(socket.assigns.board) do
      {:error, message} -> put_flash(socket, :info, message)
      {:ok, board} -> socket |> assign(board: board) |> assign_shapes
    end
  end

  defp pick(socket, name) do
    update(socket, :board, &Game.pick_pento(&1, name))
  end
end
