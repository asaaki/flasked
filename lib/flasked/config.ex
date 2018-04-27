defmodule Flasked.Config do
  @moduledoc false

  def check do
    unless keys_present? do
      raise(ArgumentError, message: ":otp_app and :map_file or :map_data are required in :flasked configuration")
    end
  end

  defp keys_present? do
    flasked_env = Application.get_all_env(:flasked)
    Dict.has_key?(flasked_env, :otp_app) && \
      (Dict.has_key?(flasked_env, :map_data) || Dict.has_key?(flasked_env, :map_file))
  end

  def otp_app, do: Application.get_env(:flasked, :otp_app)
  def map_data, do: Application.get_env(:flasked, :map_data)
  def map_file, do: Application.get_env(:flasked, :map_file)
end
