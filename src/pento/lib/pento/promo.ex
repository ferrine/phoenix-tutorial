defmodule Pento.Promo do
  alias Pento.Promo.Recepient

  def change_recepient(%Recepient{} = recepient, attrs \\ %{}) do
    Recepient.changeset(recepient, attrs)
  end

  def send_promo(recepient, attrs) do
    data = recepient
    |> Recepient.changeset(attrs)
    # dummy email send
    case data do
      %{valid?: true} ->
        {:ok, "Email sent"}
      %{valid?: false} ->
        {:error, data}
    end
  end
end
