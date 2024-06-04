defmodule PentoWeb.SurveyResultsLiveTest do
  import Phoenix.LiveViewTest
  use PentoWeb.ConnCase
  alias Phoenix.Component
  alias Pento.Survey
  alias PentoWeb.Admin.SurveyResultsLive
  import Pento.{CatalogFixtures, SurveyFixtures, AccountsFixtures}

  defp create_product(_) do
    %{product: product_fixture(%{name: "Test Game"})}
  end

  defp create_user(_) do
    %{user: user_fixture()}
  end

  defp create_rating(stars, user, product) do
    %{rating: rating_fixture(%{stars: stars, user_id: user.id, product_id: product.id})}
  end

  defp create_demographic(user) do
    %{demographic: demographic_fixture(%{user_id: user.id})}
  end

  defp create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  describe "Socket State" do
    setup [
      :create_user,
      :create_product,
      :create_socket
    ]

    setup %{user: user1} do
      create_demographic(user1)
      user2 = user_fixture(%{email: "example2@email.com"})
      create_demographic(user2)
      [user2: user2]
    end

    test "no ratings exist", %{socket: socket} do
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)
      assert socket.assigns.products_with_average_ratings == [{"Test Game", 0}]
    end

    test "rating exist", %{socket: socket, user: user, product: product} do
      create_rating(2, user, product)
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)
      assert socket.assigns.products_with_average_ratings == [{"Test Game", 2}]
    end

    test "all not reassigned(age)", %{socket: socket} do
      socket = Component.assign(socket, :age_group_filter, "18 and under")
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)
      assert socket.assigns.age_group_filter == "18 and under"
    end

    test "all not reassigned(gender)", %{socket: socket} do
      socket = Component.assign(socket, :gender_filter, "male")
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)
      assert socket.assigns.gender_filter == "male"
    end
  end
end
