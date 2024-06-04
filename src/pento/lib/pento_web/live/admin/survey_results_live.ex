defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  use PentoWeb, :chart
  alias Pento.Catalog
  alias Contex.Plot

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_age_filter()
     |> assign_gender_filter()
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  defp assign_age_filter(%{assigns: %{age_group_filter: _}} = socket) do
    # do not reassign
    socket
  end

  defp assign_age_filter(socket) do
    socket
    |> assign(:age_group_filter, "all")
  end

  defp assign_age_filter(socket, filter) do
    socket
    |> assign(:age_group_filter, filter)
  end

  defp assign_gender_filter(%{assigns: %{gender_filter: _}} = socket) do
    # do not reassign
    socket
  end

  defp assign_gender_filter(socket) do
    socket
    |> assign(:gender_filter, "all")
  end

  defp assign_gender_filter(socket, filter) do
    socket
    |> assign(:gender_filter, filter)
  end

  defp assign_products_with_average_ratings(
         %{
           assigns: %{
             age_group_filter: age_group_filter,
             gender_filter: gender_filter
           }
         } = socket
       ) do
    socket
    |> assign(
      :products_with_average_ratings,
      get_products_with_average_ratings(%{
        age_group_filter: age_group_filter,
        gender_filter: gender_filter
      })
    )
  end

  defp get_products_with_average_ratings(filter) do
    case Catalog.products_with_average_ratings(filter) do
      [] ->
        Catalog.products_with_zero_ratings()

      results ->
        results
    end
  end

  defp assign_dataset(%{assigns: %{products_with_average_ratings: products}} = socket) do
    socket
    |> assign(
      :dataset,
      make_bar_chart_dataset(products)
    )
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(
      :chart_svg,
      render_bar_chart(chart, title(), subtitle(), x_axis(), y_axis())
    )
  end

  defp title() do
    "Product Ratings"
  end

  defp subtitle() do
    "average product ratings"
  end

  defp x_axis() do
    "Product"
  end

  defp y_axis() do
    "stars"
  end

  def handle_event(
        "filter",
        %{"gender_filter" => gender_filter, "age_group_filter" => age_group_filter},
        socket
      ) do
    {:noreply,
     socket
     |> assign_age_filter(age_group_filter)
     |> assign_gender_filter(gender_filter)
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end
end
