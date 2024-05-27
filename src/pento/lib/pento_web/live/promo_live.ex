defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recepient

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_recepient()
      |> clear_form()
    }
  end

  def clear_form(socket) do
    form =
      socket.assigns.recepient
      |> Promo.change_recepient
      |> to_form
    assign(socket, :form, form)
  end

  def assign_recepient(socket) do
    socket
    |> assign(:recepient, %Recepient{})
  end

  def assign_form(socket, changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end

  def handle_event(
        "validate",
        # NOTE: this data is coming from the form changeset
        %{"recepient" => recepient_params},
        %{assigns: %{recepient: recepient}} = socket) do
    changeset =
      recepient
      |> Promo.change_recepient(recepient_params)
      |> Map.put(:action, :validate)
    # NOTE: assign_form is a nice helper defined above to assign to_form(changeset) to :form
    {:noreply, assign_form(socket, changeset)}
  end
end
