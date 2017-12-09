# You sit for a while and record part of the stream (your puzzle input). The characters represent
# groups - sequences that begin with { and end with }. Within a group, there are zero or more
# other things, separated by commas: either another group or garbage. Since groups can contain
# other groups, a } only closes the most-recently-opened unclosed group - that is, they are
# nestable. Your puzzle input represents a single, large group which itself contains many smaller
# ones.
# 
# Sometimes, instead of a group, you will find garbage. Garbage begins with < and ends with >.
# Between those angle brackets, almost any character can appear, including { and }. Within
# garbage, < has no special meaning.
# 
# In a futile attempt to clean up the garbage, some program has canceled some of the characters
# within it using !: inside garbage, any character that comes after ! should be ignored, including
# <, >, and even another !.
# 
# You don't see any characters that deviate from these rules. Outside garbage, you only find
# well-formed groups, and garbage always terminates according to the rules above.
# 
# Here are some self-contained pieces of garbage:
# 
# <>, empty garbage.
# <random characters>, garbage containing random characters.
# <<<<>, because the extra < are ignored.
# <{!>}>, because the first > is canceled.
# <!!>, because the second ! is canceled, allowing the > to terminate the garbage.
# <!!!>>, because the second ! and the first > are canceled.
# <{o"i!a,<{i<a>, which ends at the first >.
# Here are some examples of whole streams and the number of groups they contain:
# 
# {}, 1 group.
# {{{}}}, 3 groups.
# {{},{}}, also 3 groups.
# {{{},{},{{}}}}, 6 groups.
# {<{},{},{{}}>}, 1 group (which itself contains garbage).
# {<a>,<a>,<a>,<a>}, 1 group.
# {{<a>},{<a>},{<a>},{<a>}}, 5 groups.
# {{<!>},{<!>},{<!>},{<a>}}, 2 groups (since all but the last > are canceled).
#
# Your goal is to find the total score for all groups in your input. Each group is assigned a
# score which is one more than the score of the group that immediately contains it. (The outermost
# group gets a score of 1.)

defmodule Puzzle do
  def call(input) do
    input
    |> String.codepoints
    |> score(0)
  end

  def score(["<" | rest], depth) do
    garbage(rest) |> score(depth)
  end
  def score(["{" | rest], depth) do
    score(rest, depth + 1)
  end
  def score(["}" | rest], depth) do
    score(rest, depth - 1) + depth
  end
  def score([_ | rest], depth) do
    score(rest, depth)
  end
  def score([], 0) do
    0
  end

  def garbage(["!" | [_ | rest]]) do
    garbage(rest)
  end
  def garbage([">" | rest]) do
    rest
  end
  def garbage([_ | rest]) do
    garbage(rest)
  end
end

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  test "1", do: assert Puzzle.call("{}") == 1
  test "1a", do: assert Puzzle.call("{},{}") == 2
  test "1b", do: assert Puzzle.call("{!},{}") == 2
  test "2", do: assert Puzzle.call("{{{}}}") == 6
  test "3", do: assert Puzzle.call("{{},{}}") == 5
  test "4", do: assert Puzzle.call("{{{},{},{{}}}}") == 16
  test "5", do: assert Puzzle.call("{<a>,<a>,<a>,<a>}") == 1
  test "6", do: assert Puzzle.call("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
  test "7", do: assert Puzzle.call("{{<!!>},{<!!>},{<!!>},{<!!>}}") == 9
  test "8", do: assert Puzzle.call("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3
end

File.read!("input-day9.txt")
|> Puzzle.call
|> IO.inspect(label: "Answer")
