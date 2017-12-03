# You come across an experimental new kind of memory stored on an infinite two-dimensional grid.
# 
# Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and
# then counting up while spiraling outward. For example, the first few squares are allocated like
# this:
# 
# 37  36  35  34  33  32  31
# 38  17  16  15  14  13  30
# 39  18   5   4   3  12  29
# 40  19   6   1   2  11  28  <- 0 1
# 41  20   7   8   9  10  27  <- 1 3
# 42  21  22  23  24  25  26  <- 2 5
# 43  44  45  46  47  48  49  <- 3 7
# While this is very space-efficient (no squares are skipped), requested data must be carried back
# to square 1 (the location of the only access port for this memory system) by programs that can
# only move up, down, left, or right. They always take the shortest path: the Manhattan Distance
# between the location of the data and square 1.
# 
# For example:
# 
# Data from square 1 is carried 0 steps, since it's at the access port.
# Data from square 12 is carried 3 steps, such as: down, left, left.
# Data from square 23 is carried only 2 steps: up twice.
# Data from square 1024 must be carried 31 steps.
# How many steps are required to carry the data from the square identified in your puzzle input all the way to the access port?
# 
# Your puzzle input is 347991.

defmodule Puzzle5 do
  require Integer

  #@max_n = 591

  def call(input) do
    {circle, base} = (0..591)
             |> Enum.map(fn x -> {x, x * 2 + 1} end)
             |> Enum.find(fn {x, base} ->
      input <= :math.pow(base, 2)
    end)

    #prev_circle_end = :math.pow((circle - 1) * 2 + 1)

    max = round(:math.pow(base, 2))
    circle + abs(Integer.mod(max - input, base - 1) - div(base - 1, 2))
  end
end

ExUnit.start()

defmodule Puzzle5Test do
  use ExUnit.Case

  test "8" do
    assert Puzzle5.call(8) == 1
  end

  test "9" do
    assert Puzzle5.call(9) == 2
  end

  test "12" do
    assert Puzzle5.call(12) == 3
  end

  test "23" do
    assert Puzzle5.call(23) == 2
  end

  test "26" do
    assert Puzzle5.call(26) == 5
  end

  test "36" do
    assert Puzzle5.call(36) == 5
  end

  test "37" do
    assert Puzzle5.call(37) == 6
  end

  test "48" do
    assert Puzzle5.call(48) == 5
  end

  test "49" do
    assert Puzzle5.call(49) == 6
  end

  test "1024" do
    assert Puzzle5.call(1024) == 31
  end
end

IO.puts Puzzle5.call(347991)
