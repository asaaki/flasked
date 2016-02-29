defmodule Flasked.DistillerTest do
  use ExUnit.Case
  doctest Flasked.Distiller

  alias Flasked.Distiller

  test "convert/2 dict" do
    raw_value = "this:is,a:dictionary"

    assert Distiller.convert(raw_value, :dict) == [this: "is", a: "dictionary"]
  end

  test "convert/2 dict_of_integers" do
    raw_value = "one:1,two:2,three:3"

    assert Distiller.convert(raw_value, :dict_of_integers) == [one: 1, two: 2, three: 3]
  end
end
