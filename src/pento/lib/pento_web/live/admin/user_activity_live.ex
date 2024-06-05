defmodule PentoWeb.Admin.UserActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  def update(_assigns, socket) do
    {:ok,
     socket
    |> assign_user_activity()}
  end

  defp assign_user_activity(socket) do
    socket
    |> assign(:user_activity, Presence.list_products_and_users())
  end
end