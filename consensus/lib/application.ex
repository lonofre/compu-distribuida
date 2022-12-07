defmodule Consensus.Application do

  use Application

  @n_friends 10

  def start(_, _) do
    Consensus.start(@n_friends)
    {:ok, self()}
  end

end
