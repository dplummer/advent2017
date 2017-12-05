# The message includes a list of the offsets for each jump. Jumps are relative: -1 moves to the
# previous instruction, and 2 skips the next one. Start at the first instruction in the list. The
# goal is to follow the jumps until one leads outside the list.
# 
# In addition, these instructions are a little strange; after each jump, the offset of that
# instruction increases by 1. So, if you come across an offset of 3, you would move three
# instructions forward, but change it to a 4 for the next time it is encountered.
# 
# For example, consider the following list of jump offsets:
# 
# 0
# 3
# 0
# 1
# -3
# Positive jumps ("forward") move downward; negative jumps move upward. For legibility in this
# example, these offset values will be written all on one line, with the current instruction
# marked in parentheses. The following steps would be taken before an exit is found:
# 
# (0) 3  0  1  -3  - before we have taken any steps.
# (1) 3  0  1  -3  - jump with offset 0 (that is, don't jump at all). Fortunately, the instruction is then incremented to 1.
#  2 (3) 0  1  -3  - step forward because of the instruction we just modified. The first instruction is incremented again, now to 2.
#  2  4  0  1 (-3) - jump all the way to the end; leave a 4 behind.
#  2 (4) 0  1  -2  - go back to where we just were; increment -3 to -2.
#  2  5  0  1  -2  - jump 4 steps forward, escaping the maze.
# In this example, the exit is reached in 5 steps.



defmodule Puzzle do
  def call(input) do
    data = input
    |> String.split("\n")
    |> Enum.reject(fn line -> line == "" end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.map(fn {v, k} -> {k, v} end)
    |> Enum.into(%{})

    do_jumps(data, 0, 0, Enum.count(data))
  end

  def do_jumps(_, pos, count, _max) when pos < 0, do: count
  def do_jumps(_, pos, count, max) when pos >= max, do: count
  def do_jumps(data, pos, count, max) do
    {value, updated_data} = Map.get_and_update!(data, pos, & {&1, &1 + 1})
    do_jumps(updated_data, pos + value, count + 1, max)
  end
end

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  test "3" do
    input = """
0
3
0
1
-3
    """
    assert Puzzle.call(input) == 5
  end
end

File.read!("input-day5.txt")
|> Puzzle.call
|> IO.inspect(label: "Answer: ")
