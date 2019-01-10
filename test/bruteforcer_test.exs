defmodule BruteforcerTest do
  use ExUnit.Case

  test "password_validation" do
    assert Bruteforcer.password_validation("aaaaa1") == false
    assert Bruteforcer.password_validation("AAAA11") == false
    assert Bruteforcer.password_validation("aAaAaA") == false
    assert Bruteforcer.password_validation("aA1aaa") == true
  end

  test "#start" do
    res = Bruteforcer.start
    assert res == []
  end
end
