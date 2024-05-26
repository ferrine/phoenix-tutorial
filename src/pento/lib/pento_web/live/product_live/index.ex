defmodule PentoWeb.ProductLive.Index do
  # for the live_module action
  # in the book navigate was described instead.
  # this change was introduced in
  # https://github.com/phoenixframework/phoenix/commit/47b8ac061f4ddca5ae9d0cc7ed9a1c590f338edb#diff-98799d23ca76694dec61fdb11327dc117ae19084d3b5150805204df06a0c05d2R24
  # on Feb 14, 2023
  # and enabled the possiblity to not call mount/3 function on the parent view. So minimal updates are propagated.
  # previously, the default table component had a naive implementation with list of possible rows.
  # In that same PR the change was introduced to that core component that is very interesting
  # https://github.com/phoenixframework/phoenix/commit/47b8ac061f4ddca5ae9d0cc7ed9a1c590f338edb#diff-d84568fb24f951fcecda1f4c6de916e4c0899869e702b350d10237ba0dc30c81R470
  # this adds a function argument to the table component to modify the row if needed
  #
  # https://github.com/phoenixframework/phoenix/commit/47b8ac061f4ddca5ae9d0cc7ed9a1c590f338edb#diff-b6c55a2ac979fa384a633e8f7dc2400555f672cba24f3f3269cc4cba08c559c2R495
  # will make sure to only use the update method on live stream rows
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Catalog.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :products, Catalog.list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({PentoWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end
end
