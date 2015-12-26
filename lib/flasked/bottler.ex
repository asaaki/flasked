defmodule Flasked.Bottler do
  @moduledoc false

  alias Flasked.Environment
  alias Flasked.Board
  alias Flasked.Distiller
  alias Flasked.Blender

  def run do
    for {app, template} <- Board.mapping do
      apply_env_vars(app, process(template))
    end
  end

  defp apply_env_vars(app, applied_env_vars) do
    for {key, value} <- applied_env_vars do
      old_value = Application.get_env(app, key)
      merged_value = Blender.combine(old_value, value)
      Application.put_env app, key, merged_value, [persistent: true]
    end
  end

  defp process(template) when is_map(template) do
    Enum.reduce(template, %{}, fn({key, value}, tpl) ->
      new_value = process_value(value)
      Map.put(tpl, key, new_value)
    end)
  end

  defp process(template) when is_list(template) do
    Enum.reduce(template, [], fn({key, value}, tpl) ->
      new_value = process_value(value)
      tpl ++ [{key, new_value}]
    end)
  end

  defp process(template), do: template

  defp process_value(value) when is_map(value), do: process(value)
  defp process_value(value) when is_list(value), do: process(value)
  defp process_value(value), do: prepare(value)

  defp prepare({:flasked, value}), do: prepare({:flasked, value, :string})

  defp prepare({:flasked, value, type}) do
    case is_env_var(value) do
      true -> distill(value, type)
      _ -> raise(ArgumentError, message: "No ENV variable #{value} given and no default specified")
    end
  end
  defp prepare({:flasked, value, type, default}) do
    case is_env_var(value) do
      true -> distill(value, type)
      _ -> default
    end
  end
  defp prepare(anything), do: anything

  defp is_env_var(value), do: Map.has_key?(Environment.env, value)

  defp distill(value, type) do
    case Map.fetch(Environment.env, value) do
      {:ok, raw_value} -> Distiller.convert(raw_value, type)
      _ -> value
    end
  end
end
