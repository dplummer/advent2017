

defmodule Puzzle do
  def call(input) do
    {name, _, _} = input
    |> String.split("\n")
    |> Enum.reject(fn line -> line == "" end)
    |> Enum.map(&parse/1)
    |> Enum.reject(fn {_, _, []} -> true ; _ -> false end)
    |> highlander()
    name
  end

  def highlander(rows), do: highlander(rows, rows)

  def highlander([{name, _, _} = head | rest], all) do
    if Enum.any?(all, fn {_, _, children} -> Enum.any?(children, & &1 == name) end) do
      highlander(rest, all)
    else
      head
    end
  end
  #  def call(input) do
  #    [{name, _}] = input
  #    |> String.split("\n")
  #    |> Enum.reject(fn line -> line == "" end)
  #    |> Enum.map(&parse/1)
  #    |> Enum.reduce([], &main_reducer/2)
  #
  #    name
  #  end
  #
  #  def main_reducer {name, _weight, children}, acc do
  #    cond do
  #      already_a_child?(acc, name) ->
  #        update_as_child(acc, name, children)
  #      is_parent?(acc, children) ->
  #        update_as_parent(acc, name, children)
  #      true ->
  #        [{name, children} | acc]
  #    end
  #  end
  #
  #  def already_a_child?(acc, name) do
  #    Enum.any?(acc, fn
  #      {_, children} -> already_a_child?(children, name)
  #      child when is_binary(child) -> child == name
  #    end)
  #  end
  #
  #  def is_parent?(acc, names) do
  #    Enum.any?(acc, fn {name, _children} -> Enum.any?(names, & &1 == name) end)
  #  end
  #
  #  def update_as_child(acc, newname, newchildren) do
  #    Enum.map(acc, fn
  #      {name, children} ->
  #        {name, update_as_child(children, newname, newchildren)}
  #      child when is_binary(child) ->
  #        if child == newname do
  #          {newname, newchildren}
  #        else
  #          child
  #        end
  #    end)
  #  end
  #
  #  def update_as_parent(acc, name, children) do
  #    {my_children, others} = Enum.split_with(acc, fn
  #      their_name -> Enum.any?(children, fn
  #        {my_child_name, _} -> my_child_name == their_name
  #        child when is_binary(child) -> child == their_name
  #      end)
  #    end)
  #    [{name, Enum.map(children, fn
  #      childname -> case Enum.find(my_children, fn {my_child_name, _} -> my_child_name == childname end) do
  #        nil -> {childname, []}
  #        found -> found
  #      end
  #    end)} | others]
  #  end

  def parse(line) do
    case Regex.scan(~r/(\w+) \((\d+)\)( -> )?(.+)?/, line) do
      [[_, name, weight]] -> {name, weight, []}
      [[_, name | [weight | [_ | [children]]]]] -> {name, weight, String.split(children, ", ")}
    end
  end
end

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  test "case 1" do
    input = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
    """
    assert Puzzle.call(input) == "tknk"
  end

  #  test "case 2" do
  #    input = """
  #fwft (72) -> ktlj, cntj, xhth
  #    """
  #    assert Puzzle.call(input) == "fwft"
  #  end
end

File.read!("input-day7.txt")
|> Puzzle.call
|> IO.inspect(label: "Answer: ")
