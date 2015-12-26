defmodule Flasked.Distiller do
  @moduledoc false

  def convert(<<>>, :string), do: ""
  def convert(<<>>, :atom), do: nil
  def convert(<<>>, :integer), do: 0
  def convert(<<>>, :float), do: 0.0
  def convert(<<>>, :boolean), do: false
  def convert(<<>>, :module), do: convert_module("Undefined.Module")
  def convert(<<>>, :list), do: []
  def convert(<<>>, :list_of_atoms), do: []
  def convert(<<>>, :list_of_integers), do: []
  def convert(<<>>, :list_of_floats), do: []
  def convert(<<>>, :dict), do: []
  def convert(<<>>, _), do: nil

  def convert(raw_value, :string),
    do: raw_value
  def convert(raw_value, :atom),
    do: String.to_atom(raw_value)
  def convert(raw_value, :integer),
    do: String.to_integer(raw_value)
  def convert(raw_value, :float),
    do: String.to_float(raw_value)
  def convert(raw_value, :boolean),
    do: convert_boolean(raw_value)
  def convert(raw_value, :module),
    do: convert_module(raw_value)
  def convert(raw_value, :list),
    do: String.split(raw_value, ",")
  def convert(raw_value, :list_of_atoms),
    do: Enum.map(convert(raw_value, :list), &(String.to_atom(&1)))
  def convert(raw_value, :list_of_integers),
    do: Enum.map(convert(raw_value, :list), &(String.to_integer(&1)))
  def convert(raw_value, :list_of_floats),
    do: Enum.map(convert(raw_value, :list), &(String.to_float(&1)))
  def convert(raw_value, :dict) do
    raw_value
    |>convert(:list)
    |> Enum.map(fn(pair) ->
      [k, v] = String.split(pair, ":")
      {String.to_atom(k), v}
    end)
  end
  def convert(raw_value, _),
    do: raw_value

  defp convert_boolean(value) do
    case value do
      "TRUE" -> true
      "true" -> true
      "FALSE" -> false
      "false" -> false
      _ -> false
    end
  end

  defp convert_module(raw_value) do
    raw_value
    |> String.split(".")
    |> Module.concat
  end
end
