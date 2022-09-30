defmodule Worker do

  @doc """
  Creates a process that is used once. It generates
  the primes number from a giver range
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

  def get_result do
    receive do
      {:ok, primes} -> primes
    end
  end

  @doc """
  The leader process who contains state
  """
  def leader(intervals, n_childs) do
    caller = self()
    data = %{intervals: intervals, primes: [], childs: n_childs}
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
      # Waits to all its childs finish
      {:ok} ->
        new_data = Map.put(data, :childs, data.childs - 1)
        if new_data.childs == 0 do
          send(caller, {:ok, new_data.primes})
        else
          leader_loop(caller, new_data)
        end
    end
  end

  @doc """
  Process that find prime numbers
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
        primes = find_primes2(from, to)
        send(parent, {:primes, primes, self()})
        child_loop(parent)
      {:finish} ->
        send(parent, {:ok})
    end
  end


end