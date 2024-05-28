defmodule Pento.Search.Query do
  defstruct [:approx]
  @types %{approx: :string}

  import Ecto.Changeset

  def changeset(%__MODULE__{} = query, attrs) do
    {query, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:approx])
    |> validate_length(:approx, min: 1)
  end
end
