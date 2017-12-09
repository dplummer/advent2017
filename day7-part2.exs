# One program at the bottom supports the entire tower. It's holding a large disc, and on the disc
# are balanced several more sub-towers. At the bottom of these sub-towers, standing on the bottom
# disc, are other programs, each holding their own disc, and so on. At the very tops of these
# sub-sub-sub-...-towers, many programs stand simply keeping the disc below them balanced but with
# no disc of their own.
# 
# You offer to help, but first you need to understand the structure of these towers. You ask each
# program to yell out their name, their weight, and (if they're holding a disc) the names of the
# programs immediately above them balancing on that disc. You write this information down (your
# puzzle input). Unfortunately, in their panic, they don't do this in an orderly fashion; by the
# time you're done, you're not sure which program gave which information.
# 
# For example, if your list is the following:
# 
# pbga (66)
# xhth (57)
# ebii (61)
# havc (66)
# ktlj (57)
# fwft (72) -> ktlj, cntj, xhth
# qoyq (66)
# padx (45) -> pbga, havc, qoyq
# tknk (41) -> ugml, padx, fwft
# jptl (61)
# ugml (68) -> gyxo, ebii, jptl
# gyxo (61)
# cntj (57)
# ...then you would be able to recreate the structure of the towers that looks like this:
# 
#                 gyxo
#               /     
#          ugml - ebii
#        /      \     
#       |         jptl
#       |        
#       |         pbga
#      /        /
# tknk --- padx - havc
#      \        \
#       |         qoyq
#       |             
#       |         ktlj
#        \      /     
#          fwft - cntj
#               \     
#                 xhth
# In this example, tknk is at the bottom of the tower (the bottom program), and is holding up
# ugml, padx, and fwft. Those programs are, in turn, holding up other programs; in this example,
# none of those programs are holding up any other programs, and are all the tops of their own
# towers. (The actual tower balancing in front of you is much larger.)
# 
# Before you're ready to help them, you need to make sure your information is correct. What is the
# name of the bottom program?
# 
# Your puzzle answer was hmvwl.
# 
# The first half of this puzzle is complete! It provides one gold star: *
# 
# --- Part Two ---
# The programs explain the situation: they can't get down. Rather, they could get down, if they
# weren't expending all of their energy trying to keep the tower balanced. Apparently, one program
# has the wrong weight, and until it's fixed, they're stuck here.
# 
# For any program holding a disc, each program standing on that disc forms a sub-tower. Each of
# those sub-towers are supposed to be the same weight, or the disc itself isn't balanced. The
# weight of a tower is the sum of the weights of the programs in that tower.
# 
# In the example above, this means that for ugml's disc to be balanced, gyxo, ebii, and jptl must
# all have the same weight, and they do: 61.
# 
# However, for tknk to be balanced, each of the programs standing on its disc and all programs
# above it must each match. This means that the following sums must all be the same:
# 
# ugml + (gyxo + ebii + jptl) = 68 + (61 + 61 + 61) = 251
# padx + (pbga + havc + qoyq) = 45 + (66 + 66 + 66) = 243
# fwft + (ktlj + cntj + xhth) = 72 + (57 + 57 + 57) = 243
# As you can see, tknk's disc is unbalanced: ugml's stack is heavier than the other two. Even
# though the nodes above ugml are balanced, ugml itself is too heavy: it needs to be 8 units
# lighter for its stack to weigh 243 and keep the towers balanced. If this change were made, its
# weight would be 60.
# 
# Given that exactly one program is the wrong weight, what would its weight need to be to balance
# the entire tower?

defmodule Puzzle do

  defmodule Node do
    defstruct [:name, :weight, :children, :total_weight]
  end
 
  def call(input) do
    nodes = input
    |> String.split("\n")
    |> Enum.reject(& &1 == "")
    |> Enum.map(&parse/1)

    head = find_head(nodes)

    build_tree(head, Enum.reject(nodes, & &1 == head))
    |> calculate_weights()
    |> find_imbalance(0)
    0
  end

  def find_imbalance(tree, depth) do
    if Enum.map(tree.children, & &1.total_weight) |> Enum.uniq |> length != 1 do
      Enum.each(tree.children, fn node -> IO.inspect {depth, node.total_weight, node.weight} end)
      Enum.each(tree.children, &find_imbalance(&1, depth + 1))
    end
  end

  def print_weights(tree) do
    tree
    |> inspect_weight(0)
    |> List.flatten
    |> Enum.sort_by(fn {level, _, _, _} -> level end)
    |> Enum.each(&IO.inspect/1)
  end

  def inspect_weight(tree, depth) do
    [
      {depth, tree.total_weight, tree.weight, tree.name}
      |
      Enum.map(tree.children, & inspect_weight(&1, depth + 1))
    ]
  end

  def calculate_weights(%{children: []} = leaf) do
    %{leaf | total_weight: leaf.weight}
  end
  def calculate_weights(tree) do
    tree = %{tree | children: Enum.map(tree.children, &calculate_weights/1)}

    %{tree | total_weight: Enum.reduce(tree.children, 0, fn child, acc -> child.total_weight + acc end) + tree.weight}
  end

  def build_tree(head, nodes) do
    %{head | children: Enum.map(head.children, fn
      childname ->
        child = Enum.find(nodes, fn %{name: ^childname} -> true ; _ -> false end)
        build_tree(child, Enum.reject(nodes, & &1 == child))
    end)}
  end

  def find_head(nodes) do
    nodes
    |> Enum.reject(fn %{children: []} -> true ; _ -> false end)
    |> highlander()
  end

  def highlander(rows), do: highlander(rows, rows)

  def highlander([%{name: name} = head | rest], all) do
    if Enum.any?(all, fn %{children: children} -> Enum.any?(children, & &1 == name) end) do
      highlander(rest, all)
    else
      head
    end
  end


  def parse(line) do
    case Regex.scan(~r/(\w+) \((\d+)\)( -> )?(.+)?/, line) do
      [[_, name, weight]] -> %Node{name: name, weight: String.to_integer(weight), children: []}
      [[_, name | [weight | [_ | [children]]]]] -> %Node{name: name, weight: String.to_integer(weight), children: String.split(children, ", ")}
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
    assert Puzzle.call(input) == 60
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
