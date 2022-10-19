defmodule Worker do

  @doc """
  Receives the prime numbers calculated by a process
  """  
  def get_result do
    receive do
      {:ok, primes} -> primes
    end
  end

end