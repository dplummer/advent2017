#   \ n  /
# nw +--+ ne
#   /    \
# -+      +-
#   \    /
# sw +--+ se
#   / s  \
defmodule Puzzle do
  def call(input) do
    input
    |> String.trim_trailing
    |> String.split(",")
    |> walk_steps({0, 0, 0})
    |> count_steps(0)
  end

  def count_steps({0, 0, 0}, count), do: count
  def count_steps({0, y, z}, count) when y > 0, do: count_steps({0, y - 1, z + 1}, count + 1)
  def count_steps({0, y, z}, count) when y < 0, do: count_steps({0, y + 1, z - 1}, count + 1)
  def count_steps({x, 0, z}, count) when x > 0, do: count_steps({x - 1, 0, z + 1}, count + 1)
  def count_steps({x, 0, z}, count) when x < 0, do: count_steps({x + 1, 0, z - 1}, count + 1)
  def count_steps({x, y, 0}, count) when x > 0, do: count_steps({x - 1, y + 1, 0}, count + 1)
  def count_steps({x, y, 0}, count) when x < 0, do: count_steps({x + 1, y - 1, 0}, count + 1)
  def count_steps({x, y, z}, count) do
    cond do
      x > y and y > z -> {x - 1, y + 1, z}
      y > x and x > z -> {x + 1, y - 1, z}
      true -> {x + 1, y, z - 1}
    end
    |> count_steps(count + 1)
  end

  def walk_steps([], {x, y, z}) do
    {x, y, z}
  end
  def walk_steps([step | rest], {x, y, z}) do
    {mx, my, mz} = case step do
      "n" ->  { 0,  1, -1}
      "ne" -> { 1,  0, -1}
      "nw" -> {-1,  1,  0}
      "s" ->  { 0, -1,  1}
      "sw" -> {-1,  0,  1}
      "se" -> { 1, -1,  0}
    end
    walk_steps(rest, {x + mx, y + my, z + mz})
  end
end

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  test "case 1", do: assert Puzzle.call("ne,ne,ne") == 3
  test "case 2", do: assert Puzzle.call("ne,ne,sw,sw") == 0
  test "case 3", do: assert Puzzle.call("ne,ne,s,s") == 2
  test "case 4", do: assert Puzzle.call("se,sw,se,sw,sw") == 3
  test "case 5", do: assert Puzzle.call("n,se,s,sw,nw,n,ne,s") == 0
end

File.read!("input-day11.txt")
|> Puzzle.call
|> IO.inspect(label: "Answer")
