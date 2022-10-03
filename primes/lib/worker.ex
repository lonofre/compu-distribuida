defmodule Worker do

  @doc """
  Creates a process that is used once. It generates
  the primes number from a giver range

  ## Parameters

    - from: Integer that indicates the lower bound
    - to: Integer that indicates the upper bound

  ## Returns
    
    - `PID` of the process
  """
  def start(from, to) do
    caller = self()
    spawn(fn -> 
      send(caller, {:ok, find_primes(from, to)})
    end)
  end

  defp find_primes(from, to) do
    Enum.filter(from..to, &Algebra.is_prime2?/1)
  end

  @doc """
  Receives the prime numbers calculated by a process
  """  
  def get_result do
    receive do
      {:ok, primes} -> primes
    end
  end

  @doc """
  Creates a leader process who coordinates and stores the computation
  of prime numbers

  ## Receives
      - intervals: List of tuples, each interval indicates the search space
        of the prime numbers
      - n_children: Integer that indicates the number of children
  """
  def leader(intervals, n_children) do
    caller = self()
    data = %{intervals: intervals, primes: [], children: n_children}
    spawn(fn -> leader_loop(caller, data) end)
  end

  defp leader_loop(caller, data) do
    receive do
      # Register a child and assigns work
      {:parent, child} -> 
        [interval | tail] = data.intervals
        {from, to} = interval
        
        send(child, {:primes, from, to})
        new_data = Map.put(data, :intervals, tail)
        leader_loop(caller, new_data)

      # Saves the prime numbers
      {:primes, primes, child} ->
        acc = data.primes
        new_data = Map.put(data, :primes, [ primes | acc ])

        if Enum.empty?(data.intervals) do
          send(child, {:finish})
          leader_loop(caller, new_data)
        else
          [interval | tail] = data.intervals
          {from, to} = interval
        
          send(child, {:primes, from, to})
          new_data = Map.put(new_data, :intervals, tail)
          
          leader_loop(caller, new_data)
        end
      # Waits to all its children to finish
      {:ok} ->
        new_data = Map.put(data, :children, data.children - 1)
        if new_data.children == 0 do
          send(caller, {:ok, new_data.primes})
        else
          leader_loop(caller, new_data)
        end
    end
  end

  @doc """
  Creates a process that finds prime numbers

  ## Receives
    - parent: `PID` of the parent process
  """
  def child(parent) do
    spawn(fn -> 
      send(parent, {:parent, self()}) 
      child_loop(parent)
    end)
  end

  defp child_loop(parent) do
    receive do
      # Do work
      {:primes, from, to} ->
        primes = find_primes(from, to)
        send(parent, {:primes, primes, self()})
        child_loop(parent)
      {:finish} ->
        send(parent, {:ok})
    end
  end


end