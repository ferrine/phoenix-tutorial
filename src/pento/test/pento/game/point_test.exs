defmodule Pento.GameTest do
  use ExUnit.Case
  alias Pento.Game.{Point, Shape, Pentomino}


  defp assert_equal_continue(value, expected) do
    assert value == expected
    value
  end

  describe "test points" do
    setup do
      [point: Point.new(3, 3)]
    end
    test "movement test", %{point: point} do
      point
      |> assert_equal_continue({3, 3})
      |> Point.move({1, 0})
      |> assert_equal_continue({4, 3})
      |> Point.move({0, 1})
      |> assert_equal_continue({4, 4})
      |> Point.move({1, -1})
      |> assert_equal_continue({5, 3})
      |> Point.up()
      |> assert_equal_continue({5, 2})
      |> Point.down()
      |> assert_equal_continue({5, 3})
      |> Point.left()
      |> assert_equal_continue({4, 3})
      |> Point.right()
      |> assert_equal_continue({5, 3})
    end
  end

  describe "test pento movements" do
    setup do
      [pento: Pentomino.new(name: :l, location: {3, 3}, reflected: false, rotation: 0)]
    end

    test "down/1", %{pento: pento} do
      other = pento
      |> Pentomino.down()
      assert other.location == {3, 4}
    end

    test "up/1", %{pento: pento} do
      other = pento
      |> Pentomino.up()
      assert other.location == {3, 2}
    end

    test "left/1", %{pento: pento} do
      other = pento
      |> Pentomino.left()
      assert other.location == {2, 3}
    end

    test "right/1", %{pento: pento} do
      other = pento
      |> Pentomino.right()
      assert other.location == {4, 3}
    end

    test "rotate/1", %{pento: pento} do
      assert pento.rotation == 0
      pento = pento
      |> Pentomino.rotate()
      assert pento.rotation == 90
      pento = pento
      |> Pentomino.rotate()
      assert pento.rotation == 180
      pento = pento
      |> Pentomino.rotate()
      assert pento.rotation == 270
      pento = pento
      |> Pentomino.rotate()
      assert pento.rotation == 0
    end

    test "reflected/1", %{pento: pento} do
      assert pento.reflected == false
      pento = pento
      |> Pentomino.flip()
      assert pento.reflected == true
      pento = pento
      |> Pentomino.flip()
      assert pento.reflected == false
    end

    test "to_shape/1", %{pento: pento} do
      shape =
        pento
        |> Pentomino.rotate()
        |> Pentomino.to_shape()
      assert shape == Shape.new(:l, 90, false, {3, 3})
    end
  end
end
