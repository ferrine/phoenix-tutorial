defmodule Pento.Search do
  import Ecto.Query, only: [from: 2]
  alias Pento.Search.Query
  alias Pento.Catalog.Product
  alias Pento.Repo

  def change_query(%Query{} = query, attrs \\ %{}) do
    Query.changeset(query, attrs)
  end

  def search_catalog(query) do
    Repo.all(
      from p in Product,
        where:
          like(
            p.name,
            ^"%#{String.replace(query.approx, "%", "\\%")}%"
          )
    )
  end
end
