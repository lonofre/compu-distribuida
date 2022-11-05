defmodule MutualExclusion.Application do

  use Application

  def start(_, _) do
    Simulation.start()
  end

end