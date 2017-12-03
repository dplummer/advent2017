# 37  36  35  34  33  32  31
# 38  17  16  15  14  13  30
# 39  18   5   4   3  12  29
# 40  19   6   1   2  11  28  <- 0 1
# 41  20   7   8   9  10  27  <- 1 3
# 42  21  22  23  24  25  26  <- 2 5
# 43  44  45  46  47  48  49  <- 3 7
# 

# As a stress test on the system, the programs here clear the grid and then store the value 1 in
# square 1. Then, in the same allocation order as shown above, they store the sum of the values in
# all adjacent squares, including diagonals.
# 
# So, the first few squares' values are chosen as follows:
# 
# Square 1 starts with the value 1.
# Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
# Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
# Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
# Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.
# Once a square is written, its value does not change. Therefore, the first few squares would receive the following values:
# 
# 147  142  133  122   59
# 304    5    4    2   57
# 330   10    1    1   54
# 351   11   23   25   26
# 362  747  806--->   ...
# What is the first value written that is larger than your puzzle input?

# Your puzzle input is 347991.


defmodule Puzzle5 do
  require Integer

  def call(input) do
    brute([{0, 0, :east, 1}], input)
  end

  def brute([{lastx, lasty, lastface, _lastvalue} | _] = matrix, input) do
    #IO.puts "Input: #{input}"
    #IO.puts "Last pos: #{lastx},#{lasty} facing #{lastface}, val: #{lastvalue}"
    {x, y, face} = next_pos(lastx, lasty, lastface, matrix)
    next = calculate_value_at(x, y, matrix)
    #IO.inspect({x, y, face, next})
    if next > input do
      next
    else
      brute([{x, y, face, next} | matrix], input)
    end
  end

  def next_pos(0, 0, :east, 1), do: {1, 0, :north}
  def next_pos(x, y, :north, matrix) do
    if empty?(x - 1, y, matrix) do
      go_west(x, y)
    else
      go_north(x, y)
    end
  end
  def next_pos(x, y, :west, matrix) do
    if empty?(x, y - 1, matrix) do
      go_south(x, y)
    else
      go_west(x, y)
    end
  end
  def next_pos(x, y, :south, matrix) do
    if empty?(x + 1, y, matrix) do
      go_east(x, y)
    else
      go_south(x, y)
    end
  end
  def next_pos(x, y, :east, matrix) do
    if empty?(x, y + 1, matrix) do
      go_north(x, y)
    else
      go_east(x, y)
    end
  end

  def go_east(x, y),  do: {x + 1, y, :east}
  def go_north(x, y), do: {x, y + 1, :north}
  def go_south(x, y), do: {x, y - 1, :south}
  def go_west(x, y),  do: {x - 1, y, :west}

  def empty?(x, y, matrix) do
    !Enum.any?(matrix, fn {cx, cy, _face, _} -> cx == x && cy == y end)
  end

  def at(x, y, matrix) do
    {_, _, _face, value} = Enum.find(matrix, {nil, nil, nil, 0}, fn {cx, cy, _face, _} -> cx == x && cy == y end)
    value
  end

  def calculate_value_at(px, py, matrix) do
    Enum.sum(for x <- (-1..1), y <- (-1..1), do: at(px + x, py + y, matrix))
  end
end

ExUnit.start()

defmodule Puzzle5Test do
  use ExUnit.Case

  test "3" do
    assert Puzzle5.call(3) == 4
  end

  test "15" do
    assert Puzzle5.call(15) == 23
  end

  test "305" do
    assert Puzzle5.call(305) == 330
  end

  test "350" do
    assert Puzzle5.call(350) == 351
  end
end

IO.puts Puzzle5.call(347991)
