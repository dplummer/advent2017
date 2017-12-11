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
    |> walk_steps({0, 0, 0}, 0)
  end

  def count_steps({0, 0, 0}, count), do: count
  def count_steps({0, y, _z}, count) when y > 0, do: count + y
  def count_steps({0, _y, z}, count) when z > 0, do: count + z
  def count_steps({x, 0, _z}, count) when x > 0, do: count + x
  def count_steps({x, 0, z}, count) when x < 0, do: count + z
  def count_steps({x, _y, 0}, count) when x > 0, do: count + x
  def count_steps({x, y, 0}, count) when x < 0, do: count + y
  def count_steps({x, y, z}, count) do
    cond do
      x >= y and y >= z -> {x - 1, y, z + 1}
      x >= z and z >= y -> {x - 1, y + 1, z}
      y >= x and x >= z -> {x, y - 1, z + 1}
      y >= z and z >= x -> {x + 1, y - 1, z}
      z >= x and x >= y -> {x, y + 1, z - 1}
      z >= y and y >= x -> {x + 1, y, z - 1}
    end
    |> count_steps(count + 1)
  end

  def walk_steps([], _, max) do
    max
  end
  def walk_steps([step | rest], {x, y, z}, max) do
    {mx, my, mz} = case step do
      "n" ->  { 0,  1, -1}
      "ne" -> { 1,  0, -1}
      "nw" -> {-1,  1,  0}
      "s" ->  { 0, -1,  1}
      "sw" -> {-1,  0,  1}
      "se" -> { 1, -1,  0}
    end
    new_pos = {x + mx, y + my, z + mz}
    steps = count_steps(new_pos, 0)
    max = if max > steps, do: max, else: steps
    walk_steps(rest, new_pos, max)
  end
end

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  test "case 1", do: assert Puzzle.call("ne,ne,ne") == 3
  test "case 2", do: assert Puzzle.call("ne,ne,sw,sw") == 2
  test "case 3", do: assert Puzzle.call("ne,ne,s,s") == 2
  test "case 4", do: assert Puzzle.call("se,sw,se,sw,sw") == 3
  test "case 5", do: assert Puzzle.call("n,se,s,sw,nw,n,ne,s") == 1
end

File.read!("input-day11.txt")
|> Puzzle.call
|> IO.inspect(label: "Answer")
