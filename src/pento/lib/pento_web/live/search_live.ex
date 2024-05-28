defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view
  alias Pento.Search
  alias Pento.Search.Query

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream(:products, [])
      |> assign_query()
      |> clear_form()
    }
  end
  def assign_query(socket) do
    socket
    |> assign(:query, %Query{})
  end

  def clear_form(socket) do
    form =
       socket.assigns.query
      |> Search.change_query
      |> to_form
    assign(socket, :form, form)
  end

  def handle_event("search", %{"query" => query_params}, socket) do
    query = socket.assigns.query
    changeset =
      query
      |> Search.change_query(query_params)
    with {:ok, query} <- Ecto.Changeset.apply_action(changeset, :validate) do
      {:noreply,
       socket
       |> stream(:products, Search.search_catalog(query), reset: true)
       |> assign(:form, to_form(changeset))
      }
    else
      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
