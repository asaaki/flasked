defmodule Flasked.Config do
  @moduledoc false

  def check do
    unless keys_present? do
      raise(ArgumentError, message: "Missing :otp_app and/or :map_file in :flasked configuration")
    end
  end

  defp keys_present? do
    flasked_env = Application.get_all_env(:flasked)
    Dict.has_key?(flasked_env, :otp_app) && Dict.has_key?(flasked_env, :map_file)
  end

  def otp_app, do: Application.get_env(:flasked, :otp_app)
  def map_file, do: Application.get_env(:flasked, :map_file)
end
