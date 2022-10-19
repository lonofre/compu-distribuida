defmodule RangePrimesFinder do

  @doc """
  Assigns to n_workers a range to find prime numbers.
  Each range has the same length.
  """
  def start(n_workers, upper_bound) do
    block = div(upper_bound, n_workers)
    0..(n_workers - 1)
    |> Enum.to_list()
    |> Enum.map(fn wid ->
      start_worker(wid * block + 1, min((wid + 1) * block, upper_bound)) end)
    |> Enum.map(fn _ -> Worker.get_result() end)
    |> Enum.concat()
    |> Enum.sort()
  end

  defp start_worker(from, to) do
    caller = self()
    spawn(fn -> 
      send(caller, {:ok, find_primes(from, to)})
    end)
  end

  defp find_primes(from, to) do
    Enum.filter(from..to, &Algebra.is_prime?/1)
  end


end