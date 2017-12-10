
defmodule Puzzle do
  defmodule Step do
    defstruct [:list, :curr, :skip, :input]

    def init(max) do
      %__MODULE__{list: Enum.to_list(0..max), curr: 0, skip: 0}
    end
  end

  def call(input, max) do
    %Step{list: [a | [b | _]]} = input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(Step.init(max), fn
      input, step ->
        res = %{step | input: input} |> iter
        #IO.inspect(length(res.list), label: "Length")
        #IO.inspect(res.list, limit: 256)
        res
    end)
    a * b
  end

  def iter(step) do
    if length(reverse_section(step.list, step.curr, step.input)) > 256 do
      IO.inspect(step, limit: 500)
      raise "ok"
    end
    %Step{
      list: reverse_section(step.list, step.curr, step.input),
      curr: move_cursor(step.curr, step.skip, step.input, length(step.list)),
      skip: step.skip + 1
    }
  end

  def move_cursor(curr, skip, input, max) do
    rem(curr + skip + input, max)
  end

  def reverse_section(list, _, 0), do: list
  def reverse_section(list, _, 1), do: list
  def reverse_section(list, 0, amount) do
    head = Enum.slice(list, 0..(amount - 1)) |> Enum.reverse
    tail = Enum.slice(list, amount..-1)
    head ++ tail
  end
  def reverse_section(list, pos, amount) do
    zero_pos(list, pos)
    |> reverse_section(0, amount)
    |> zero_pos(-1 * pos)
  end

  def zero_pos(list, pos) do
    Enum.slice(list, pos..-1) ++ Enum.slice(list, 0..pos-1)
  end
end

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  alias Puzzle.Step

  test "case 1" do
    assert Puzzle.call("3,4,1,5", 4) == 12
  end

  test "iter 1" do
    assert Puzzle.iter(%Step{list: [0,1,2,3,4], curr: 0, skip: 0, input: 3}) ==
      %Step{list: [2,1,0,3,4], curr: 3, skip: 1}
  end

  test "iter 2" do
    assert Puzzle.iter(%Step{list: [2,1,0,3,4], curr: 3, skip: 1, input: 4}) ==
      %Step{list: [4, 3, 0, 1, 2], curr: 3, skip: 2}
  end

  test "iter 3" do
    assert Puzzle.iter(%Step{list: [4, 3, 0, 1, 2], curr: 3, skip: 2, input: 1}) ==
      %Step{list: [4, 3, 0, 1, 2], curr: 1, skip: 3}
  end

  test "iter 4" do
    assert Puzzle.iter(%Step{list: [4, 3, 0, 1, 2], curr: 1, skip: 3, input: 5}) ==
      %Step{list: [3, 4, 2, 1, 0], curr: 4, skip: 4}
  end

  test "reverse_section 1" do
    assert Puzzle.reverse_section([0,1,2,3,4], 0, 3) == [2, 1, 0, 3, 4]
  end

  test "reverse_section 2" do
    assert Puzzle.reverse_section([2, 1, 0, 3, 4], 3, 4) == [4, 3, 0, 1, 2]
  end

  test "reverse_section 4" do
    assert Puzzle.reverse_section([4, 3, 0, 1, 2], 1, 5) == [3, 4, 2, 1, 0]
  end

  test "reverse_section 5" do
    input = [230, 229, 228, 227, 226, 225, 224, 223, 222, 221, 220, 219, 218, 217,
  216, 215, 214, 213, 212, 211, 210, 209, 208, 207, 206, 205, 204, 203, 202,
  201, 200, 199, 141, 142, 191, 192, 193, 194, 195, 197, 196, 198, 140, 138,
  139, 137, 136, 135, 134, 133, 132, 131, 130, 129, 128, 127, 126, 125, 124,
  123, 122, 121, 120, 119, 118, 117, 116, 115, 114, 113, 112, 111, 110, 109,
  108, 107, 106, 105, 104, 103, 102, 101, 100, 99, 98, 97, 96, 95, 94, 93, 92,
  91, 90, 89, 88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 78, 77, 76, 75, 74, 73,
  72, 71, 70, 69, 68, 67, 66, 65, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54,
  53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35,
  34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16,
  15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 189, 190, 143, 144, 145,
  146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160,
  161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175,
  176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 255, 254,
  253, 252, 251, 250, 249, 248, 247, 246, 245, 244, 243, 242, 241, 240, 239,
  238, 237, 236, 235, 234, 233, 232, 231]
    assert Puzzle.reverse_section(input, 50, 0) == input
  end


  test "move cursor 1" do
    assert Puzzle.move_cursor(0, 0, 3, 5) == 3
  end

  test "move cursor 2" do
    assert Puzzle.move_cursor(3, 1, 4, 5) == 3
  end

  test "move cursor 3" do
    assert Puzzle.move_cursor(99, 5, 10, 100) == 14
  end
end

"189,1,111,246,254,2,0,120,215,93,255,50,84,15,94,62"
|> Puzzle.call(255)
|> IO.inspect(label: "Answer")
