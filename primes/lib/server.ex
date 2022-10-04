defmodule Server do

    @doc """
    Assigns to n_workers a range to find prime numbers.
    Each range has the same length.

    ## Receives

      - n_workers: Integer that indicates the total number of processes
        that compute the prime numbers
    """
    def range_primes_finder(n_workers, upper_bound) do
      block = div(upper_bound, n_workers)
      0..(n_workers - 1)
      |> Enum.to_list()
      |> Enum.map(fn wid ->
        Worker.start(wid * block + 1, min((wid + 1) * block, upper_bound)) end)
      |> Enum.map(fn _ -> Worker.get_result() end)
      |> Enum.concat()
      |> Enum.sort()
    end

    @doc """
    One process coordinates the `n_workers` to find all
    the prime numbers up to the given `upper_bound`

    ## Receives

      - n_workers: Integer that indicates the total number of processes
        that compute the prime numbers.
    """
    def dispenser_primes_finder(n_workers, upper_bound) do
      intervals = intervals(n_workers, upper_bound)
      leader = Worker.leader(intervals, n_workers)
      0..(n_workers - 1)
      |> Enum.map(fn _ -> Worker.child(leader) end)
      
      Worker.get_result()
      |> Enum.reverse()
      |> Enum.concat()
      |> Enum.sort()
    end

    defp intervals(n_workers, upper_bound) do
      block = div(upper_bound, n_workers*2)
      0..((n_workers*2) - 1)
      |> Enum.map(fn id -> {id * block + 1, min((id + 1) * block, upper_bound)} end)
    end

    @doc """
    One process finds the primes number given a upper bound
    """
    def sieve(upper_bound) do
      Algebra.primes_to(upper_bound)
    end

end