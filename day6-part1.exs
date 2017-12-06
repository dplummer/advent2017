# In this area, there are sixteen memory banks; each memory bank can hold any number of blocks.
# The goal of the reallocation routine is to balance the blocks between the memory banks.
# 
# The reallocation routine operates in cycles. In each cycle, it finds the memory bank with the
# most blocks (ties won by the lowest-numbered memory bank) and redistributes those blocks among
# the banks. To do this, it removes all of the blocks from the selected bank, then moves to the
# next-highest-indexed memory bank and inserts one of the blocks. It continues doing this until it
# runs out of blocks; if it reaches the last memory bank, it wraps around to the first one.
# 
# The debugger would like to know how many redistributions can be done before a blocks-in-banks
# configuration is produced that has been seen before.
# 
# For example, imagine a scenario with only four memory banks:
# 
# The banks start with 0, 2, 7, and 0 blocks. The third bank has the most blocks, so it is chosen
# for redistribution.

# Starting with the next bank (the fourth bank) and then continuing to the first bank, the second
# bank, and so on, the 7 blocks are spread out over the memory banks. The fourth, first, and
# second banks get two blocks each, and the third bank gets one back. The final result looks like
# this: 2 4 1 2.

# Next, the second bank is chosen because it contains the most blocks (four). Because there are
# four memory banks, each gets one block. The result is: 3 1 2 3.

# Now, there is a tie between the first and fourth memory banks, both of which have three blocks.
# The first bank wins the tie, and its three blocks are distributed evenly over the other three
# banks, leaving it with none: 0 2 3 4.

# The fourth bank is chosen, and its four blocks are distributed such that each of the four banks
# receives one: 1 3 4 1.

# The third bank is chosen, and the same thing happens: 2 4 1 2.

# At this point, we've reached a state we've seen before: 2 4 1 2 was already seen. The infinite
# loop is detected after the fifth block redistribution cycle, and so the answer in this example
# is 5.
# 
# Given the initial block counts in your puzzle input, how many redistribution cycles must be
# completed before a configuration is produced that has been seen before?



defmodule Puzzle do
  def call(input) do
    input
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> find_inf_loop
  end

  def find_inf_loop(memory) do
    find_inf_loop(memory, [], 0)
  end
  def find_inf_loop(memory, previous, count) do
    if Enum.any?(previous, fn past -> past == memory end) do
      count
    else
      {value, index} = find_max_index(memory)
      new_memory = memory |> zero_value(index) |> redistribute(value, index + 1)

      find_inf_loop(new_memory, [memory | previous], count + 1)
    end
  end

  def find_max_index([value | rest]) do
    find_max_index(rest, 1, 0, value)
  end
  def find_max_index([], _, index, value), do: {value, index}
  def find_max_index([head | rest], curr, index, value) do
    if head > value do
      find_max_index(rest, curr + 1, curr, head)
    else
      find_max_index(rest, curr + 1, index, value)
    end
  end

  def zero_value(memory, index) do
    List.update_at(memory, index, fn _ -> 0 end)
  end

  def redistribute(memory, value, index) when length(memory) <= index do
    redistribute(memory, value, 0)
  end
  def redistribute(memory, 0, _) do
    memory
  end
  def redistribute(memory, value, index) do
    List.update_at(memory, index, & &1 + 1)
    |> redistribute(value - 1, index + 1)
  end
end

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  test "case 1", do: assert Puzzle.call("0 2 7 0") == 5
end

"5	1	10	0	1	7	13	14	3	12	8	10	7	12	0	6"
|> Puzzle.call
|> IO.inspect(label: "Answer")
