defmodule Flasked do
  @moduledoc """
  Here should be a nice documentation about Flasked.

  Unfortunately the author of this project was too lazy to move it from the README.md to this place.

  Meanwhile you could just open the aforementioned readme and be happy.

  _I feel sorry. A bit. Maybe._
  """

  use Application
  alias Flasked.Config
  alias Flasked.Bottler

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    bottle_it
    Supervisor.start_link([], [strategy: :one_for_one, name: Flasked.Supervisor])
  end

  def bottle_it do
    Config.check
    Bottler.run
    :ok
  end
end
