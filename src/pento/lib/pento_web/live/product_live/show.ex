defmodule PentoWeb.ProductLive.Show do
  use PentoWeb, :live_view

  alias PentoWeb.Presence
  alias Pento.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Catalog.get_product!(id))
     |> maybe_track_user()}
  end

  defp maybe_track_user(%{assigns: %{product: product, current_user: user, live_action: :show}} = socket) do
    if connected?(socket) do
      Presence.track_user(self(), product, user.email)
    end
    socket
  end

  defp maybe_track_user(socket) do
    socket
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
