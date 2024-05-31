defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_rating()
      |> clear_form()
    {:ok, socket}
  end

  def assign_form(socket, changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end

  def assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    socket
    |> assign(:rating, %Rating{user_id: user.id, product_id: product.id})
  end

  def clear_form(%{assigns: %{rating: rating}} = socket) do
    socket
    |> assign_form(Survey.change_rating(rating))
  end
end
