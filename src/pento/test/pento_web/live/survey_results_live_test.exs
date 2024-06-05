defmodule PentoWeb.SurveyResultsLiveTest do
  import Phoenix.LiveViewTest
  use PentoWeb.ConnCase
  alias Phoenix.Component
  alias Pento.Survey
  alias PentoWeb.Admin.SurveyResultsLive
  import Pento.{CatalogFixtures, SurveyFixtures, AccountsFixtures}

  defp create_rating(stars, user, product) do
    rating_fixture(%{stars: stars, user_id: user.id, product_id: product.id})
  end

  defp create_demographic(user, age) do
    demographic_fixture(%{
      user_id: user.id,
      year_of_birth: DateTime.utc_now().year - age
    })
  end

  defp create_simple_data(_) do
    product = product_fixture(%{name: "Test Game"})
    user1 = user_fixture(%{email: "example1@email.com"})
    user2 = user_fixture(%{email: "example2@email.com"})
    [user1: user1, user2: user2, product: product, socket: %Phoenix.LiveView.Socket{}]
  end

  describe "Socket State" do
    setup [
      :create_simple_data
    ]

    test "no ratings exist", %{socket: socket} do
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)
      assert socket.assigns.products_with_average_ratings == [{"Test Game", 0}]
    end

    test "rating exist", %{socket: socket, user1: user, product: product} do
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

    test "it filters by age group", %{conn: conn, user1: user1, product: product, user2: user2} do
      conn = log_in_user(conn, user1)
      create_demographic(user1, 16)
      create_demographic(user2, 20)
      create_rating(2, user1, product)
      create_rating(3, user2, product)
      {:ok, view, html} = live(conn, "/admin/dashboard")
      assert html =~ "<title>2.50</title>"
      html =
        view
        |> element("#filter-form")
        |> render_change(%{"age_group_filter" => "18 and under"})
      assert html =~ "<title>2.00</title>"
    end
  end
end
