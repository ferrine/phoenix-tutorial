defmodule PentoWeb.GameLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
