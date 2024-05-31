defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias Pento.Survey
  alias PentoWeb.DemographicLive
  alias __MODULE__.Component
  alias Pento.Survey.Demographic

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_demographic()
    }
  end

  defp assign_demographic(socket) do
    user = socket.assigns.current_user
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
end
