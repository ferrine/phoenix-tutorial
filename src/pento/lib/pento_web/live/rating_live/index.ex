defmodule PentoWeb.RatingLive.Index do
  use Phoenix.Component
  import Phoenix.HTML
  alias PentoWeb.RatingLive
  alias Pento.Catalog.Product
  alias Pento.Accounts.User

  attr :products, :list, required: true
  attr :current_user, User, required: true

  def product_list(assigns) do
    ~H"""
    <.heading products={@products} />
    <div class="grid grid-cols-2 gap-4 divide-y">
      <.product_rating
        :for={{p, i} <- Enum.with_index(@products)}
        current_user={@current_user}
        product={p}
        index={i}
      />
    </div>
    """
  end

  attr :products, :list, required: true

  def heading(assigns) do
    ~H"""
    <h2 class="font-medium text-2xl">
      Ratings <%= if ratings_complete?(@products), do: raw("&#x2713;") %>
    </h2>
    """
  end

  attr :product, Product, required: true
  attr :current_user, User, required: true
  attr :index, :integer, required: true
  def product_rating(assigns) do
    ~H"""
    <div>
      <%= @product.name %>
    </div>
    <%= if rating = List.first(@product.ratings) do %>
      <RatingLive.Show.stars rating={rating} product={@product} />
    <% else %>
      <div>
        <h3>
          <%= @product.name %> rating form coming soon!
        </h3>
      </div>
    <% end %>
    """
  end

  defp ratings_complete?(products) do
    Enum.all?(products, fn product ->
      not Enum.empty?(product.ratings)
    end)
  end
end
