defmodule Flasked.Environment do
  @moduledoc false

  @app_put_env_options [persistent: true]

  def env, do: env_transform(all)

  def env([]), do: env
  def env(prefix_list) when is_list(prefix_list) do
    prefix_list
    |> filter_all
    |> env_transform
  end

  # private

  defp all, do: System.get_env

  defp env_transform(env_map), do: Enum.into(env_map, %{}, &kv_transform/1)

  defp kv_transform({key, value}), do: {key_transform(key), value}

  # "FOO_BAR" => :FOO_BAR
  defp key_transform(key), do: key |> String.to_atom

  defp filter_all(prefix_list) do
    filter_env(all, prefix_list)
  end

  defp filter_env(env_map, prefix_list) do
    Enum.filter(
      env_map,
      fn ({key, _}) -> key_starts_with?(key, prefix_list) end
    )
  end

  defp key_starts_with?(key, prefix_list) do
    Enum.any?(
      prefix_list,
      fn (prefix) -> String.starts_with?(key, prefix) end
    )
  end
end
