defmodule Flasked.Blender do
  @moduledoc false

  def combine(old_value, new_value) do
    case {is_collectable(old_value), is_collectable(new_value)} do
      {true, true} ->
        combine_collectables(old_value, new_value)
      {_, _} ->
        new_value
    end
  end

  defp is_collectable(collectable), do: is_map(collectable) || is_dict(collectable)

  defp is_dict(list) when is_list(list) do
    Enum.all?(list, fn(element) ->
      is_tuple(element) && tuple_size(element) == 2
    end)
  end
  defp is_dict(_), do: false

  defp combine_collectables(old_coll, new_coll) do
    Dict.merge(old_coll, new_coll, &deep_merger/3)
  end

  defp deep_merger(_key, old_value, new_value) do
    combine(old_value, new_value)
  end
end
