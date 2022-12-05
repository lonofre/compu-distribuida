defmodule Consensus.Application do

  use Application

  def start(_, _) do
    Consensus.start(10)
    {:ok, self()}
  end

end
