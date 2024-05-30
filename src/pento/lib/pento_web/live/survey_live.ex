defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias Pento.Survey
  alias PentoWeb.DemographicLive
  alias __MODULE__.Component

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
end
