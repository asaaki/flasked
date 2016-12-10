defmodule Flasked.Board do
  @moduledoc false

  alias Flasked.Config

  def mapping do
    case Config.map_data do
      nil ->
        {data, _bindings} = Code.eval_file(otp_app_map_file_path)
        data
      data ->
        data
    end
  end

  defp otp_app_map_file_path do
    otp_app_dir <> "/" <> Config.map_file
  end

  defp otp_app_dir do
    Application.app_dir(Config.otp_app)
  end
end
