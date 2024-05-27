defmodule Pento.Promo do
  alias Pento.Promo.Recepient

  def change_recepient(%Recepient{} = recepient, attrs \\ %{}) do
    Recepient.changeset(recepient, attrs)
  end

  def send_promo(_recepient, _attrs) do
    # dummy email send
    {:ok, %Recepient{}}
  end
end
