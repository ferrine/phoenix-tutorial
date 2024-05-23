defmodule PentoWeb.WrongLive do
  alias Pento.Accounts
  use PentoWeb, :live_view

  def magic_number do
    :rand.uniform(10) |> to_string
  end

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Make a guess",
        magic_number: magic_number()
      )
    }
  end

  def time do
    DateTime.utc_now() |> to_string
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2><%= @message %></h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <br /> Page loaded at time <%= time() %> for <%= @current_user.email %>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    score = socket.assigns.score

    case guess == socket.assigns.magic_number do
      false ->
        message = "Your guess is #{guess} which is wrong, try once more"
        score = score - 1
        {:noreply, assign(socket, message: message, score: score)}

      true ->
        number = magic_number()
        message = "Congratulations you found the correct number #{guess}, try another one"
        score = score + 1
        {:noreply, assign(socket, message: message, score: score, magic_number: number)}
    end
  end
end
