defmodule Permutations do
  def combinations(a, acc \\ Stream.cycle([]))
  def combinations([head | tail], acc) do
    acc = cartesian_product(head, acc)
    combinations(tail, acc)
  end

  def combinations([], acc) do
    acc
  end

  def variants do
    Stream.concat([lower_en_chars(), upper_en_chars(), digits()])
  end

  def lower_en_chars do
    Stream.map(?a..?z, fn(x) -> <<x :: utf8>> end)
  end

  def upper_en_chars do
    Stream.map(?A..?Z, fn(x) -> <<x :: utf8>> end)
  end

  def digits do
    Stream.map(0..9, fn(x) -> to_string(x) end)
  end

  def cartesian_product(a, []) do a end

  def cartesian_product(a, b) do
    Stream.flat_map a, fn i ->
      Stream.map b, fn j ->
        i <> j
      end
    end
  end
end
