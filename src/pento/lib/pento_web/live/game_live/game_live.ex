defmodule PentoWeb.GameLive do
  use PentoWeb, :live_view
  alias PentoWeb.GameLive.Board

  def mount(%{"puzzle" => puzzle}, _session, socket) do
    {:ok, assign(socket, :puzzle, puzzle)}
  end
end
