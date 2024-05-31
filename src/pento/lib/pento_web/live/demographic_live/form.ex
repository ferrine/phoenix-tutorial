defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_demographic()
      |> clear_form()
    }
  end

  defp assign_demographic(%{assigns: %{current_user: user}} = socket) do
    socket
    |> assign(:demographic, %Demographic{user_id: user.id})
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp clear_form(%{assigns: %{demographic: demographic}} = socket) do
    assign_form(socket, Survey.change_demographic(demographic))
  end

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    demographic_params =
      demographic_params
      |> params_with_user(socket)
    {:noreply, save_demographic(socket, demographic_params)}
  end

  def params_with_user(params, %{assigns: %{current_user: user}}) do
    params
    |> Map.put("user_id", user.id)
  end

  def save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        # there is nothing to render so no need to reassign the socket
        # to it's best notify parent about the event
        send(self(), {:created_demographic, demographic})
        socket
      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end
end
