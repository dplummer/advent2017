# Each instruction consists of several parts: the register to modify, whether to increase or
# decrease that register's value, the amount by which to increase or decrease it, and a condition.
# If the condition fails, skip the instruction without modifying the register. The registers all
# start at 0. The instructions look like this:
# 
# b inc 5 if a > 1
# a inc 1 if b < 5
# c dec -10 if a >= 1
# c inc -20 if c == 10
# These instructions would be processed as follows:
# 
# Because a starts at 0, it is not greater than 1, and so b is not modified.
# a is increased by 1 (to 1) because b is less than 5 (it is 0).
# c is decreased by -10 (to 10) because a is now greater than or equal to 1 (it is 1).
# c is increased by -20 (to -10) because c is equal to 10.
# After this process, the largest value in any register is 1.
# 
# You might also encounter <= (less than or equal to) or != (not equal to). However, the CPU
# doesn't have the bandwidth to tell you what all the registers are named, and leaves that to you
# to determine.
# 
# What is the largest value in any register after completing the instructions in your puzzle input?

defmodule Puzzle do
  def call(input) do
    input
    |> String.split("\n")
    |> Enum.reject(fn line -> line == "" end)
    |> Enum.map(&parse/1)
    |> Enum.reduce(%{}, fn x, acc ->
      process(x, acc)
    end)
    |> Map.values
    |> Enum.max
  end

  def parse(line) do
    [register, action, value, "if", cond_register, comparitor, cond_value] = String.split(line)
    {{register, action, String.to_integer(value)}, {cond_register, comparitor, String.to_integer(cond_value)}}
  end

  def process({then, {cond_register, "<", cond_value}}, acc) do
    if Map.get(acc, cond_register, 0) < cond_value do
      run(then, acc)
    else
      acc
    end
  end
  def process({then, {cond_register, ">", cond_value}}, acc) do
    if Map.get(acc, cond_register, 0) > cond_value do
      run(then, acc)
    else
      acc
    end
  end
  def process({then, {cond_register, ">=", cond_value}}, acc) do
    if Map.get(acc, cond_register, 0) >= cond_value do
      run(then, acc)
    else
      acc
    end
  end
  def process({then, {cond_register, "<=", cond_value}}, acc) do
    if Map.get(acc, cond_register, 0) <= cond_value do
      run(then, acc)
    else
      acc
    end
  end
  def process({then, {cond_register, "!=", cond_value}}, acc) do
    if Map.get(acc, cond_register, 0) != cond_value do
      run(then, acc)
    else
      acc
    end
  end
  def process({then, {cond_register, "==", cond_value}}, acc) do
    if Map.get(acc, cond_register, 0) == cond_value do
      run(then, acc)
    else
      acc
    end
  end

  def run({register, "inc", value}, acc) do
    Map.update(acc, register, value, & &1 + value)
  end
  def run({register, "dec", value}, acc) do
    Map.update(acc, register, -1 * value, & &1 - value)
  end
end

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  test "case 1" do
    input = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
    """
    assert Puzzle.call(input) == 1
  end
end

File.read!("input-day8.txt")
|> Puzzle.call
|> IO.inspect(label: "Answer: ")
