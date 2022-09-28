defmodule Worker do

  def start(from, to) do

    caller = self()

    spawn(fn -> 
      send(caller, {:ok, find_primes(from, to)})
    end)

  end

  def find_primes(from, to) do
    Enum.filter(from..to, &Algebra.is_prime?/1)
  end

  def get_result do
    receive do
      {:ok, primes} -> primes
    end
  end

end