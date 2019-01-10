defmodule PermutationsTest do
  use ExUnit.Case
  doctest Permutations

  test "#cartesian_product" do
    a = Stream.map(?a..?b, fn(x) -> <<x :: utf8>> end)
    b = Stream.map(1..2, fn(x) -> to_string(x) end)
    product = Permutations.cartesian_product(a, b) |> Enum.to_list
    assert product == ["a1", "a2", "b1", "b2"]
  end

  test "#cartesian_product with empty list" do
    a = Stream.map(?a..?b, fn(x) -> <<x :: utf8>> end)
    b = []
    product = Permutations.cartesian_product(a, b) |> Enum.to_list
    assert product == ["a", "b"]
  end


  test "#variants" do
    assert Permutations.variants() |> Enum.to_list == [
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
      "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
      "u", "v", "w", "x", "y", "z", "A", "B", "C", "D",
      "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
      "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
      "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7",
      "8", "9"
    ]
  end

  test "#combinations" do
    a = Stream.map(?A..?B, fn(x) -> <<x :: utf8>> end)
    b = Stream.map(?a..?b, fn(x) -> <<x :: utf8>> end)
    c = Stream.map(1..2, fn(x) -> to_string(x) end)
    combinations = Permutations.combinations([a, b, c], []) |> Enum.to_list
    assert combinations == ["1aA", "1aB", "1bA", "1bB", "2aA", "2aB", "2bA", "2bB"]
  end

  test "#combinations long stream" do
    a = Permutations.variants()
    b = Permutations.variants()
    c = Permutations.variants()
    d = Permutations.variants()
    e = Permutations.variants()
    f = Permutations.variants()
    combinations = Permutations.combinations([a, b, c, d, e, f], []) |> Stream.take(1) |> Enum.to_list
    assert combinations == ["aaaaaa"]
  end
end
