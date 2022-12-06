defmodule Consensus.Application do

  use Application

  def start(_, _) do
    Consensus.start(5)
    {:ok, self()}
  end

end
