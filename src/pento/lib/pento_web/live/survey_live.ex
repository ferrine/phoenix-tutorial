defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias Pento.Survey
  alias Pento.Catalog
  alias PentoWeb.DemographicLive
  alias PentoWeb.RatingLive
  alias __MODULE__.Component
  alias Pento.Survey.Demographic

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_demographic()
      |> assign_products()
    }
  end

  defp assign_demographic(%{assigns: %{current_user: user}} = socket) do
    socket
    |> assign(:demographic, Survey.get_demographic_by_user(user))
  end

  def handle_info({:created_demographic, %Demographic{} = demographic}, socket) do
    # the first argument is {event, payload}, second is state which is our socket
    # in principle we can do whatever to listen to
    # optionally, type guqrd the payload so we are 200% sure it is what we expect
    # we need to return the updated state here as in plain genserver
    {:noreply,
     socket
     |> put_flash(:info, "Demographic created succesfully")
     |> assign(:demographic, demographic)
    }
  end

  def assign_products(%{assigns: %{current_user: user}} = socket) do
    socket
    |> assign(:products, Catalog.list_products_with_user_ratings(user))
  end
end
