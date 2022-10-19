defmodule DispenserPrimesFinder do

  @doc """
    Uses a leader to coordinate n procceses
    to find all prime numbers up to the given upper bound
  """
  def start(upper_bound, n_workers) do
    leader = leader(upper_bound)

    # Creates the child processes
    0..(n_workers - 1)
    |> Enum.map(fn _ -> child(leader) end)

    Worker.get_result()
    |> Enum.sort()
  end

  defp leader(upper_bound) do
    caller = self()
    state = %{ upper_bound: upper_bound, 
              primes: [], 
              children: [] }

    spawn(fn -> leader_loop(1, caller, state) end)
  end

  defp leader_loop(current_number, caller, state) do
    receive do
      # Register a child and assigns work
      {:parent, child_pid} -> 
        send(child_pid, {:is_prime, current_number})

        new_state = Map.put(state, :children, [child_pid | state.children])
        leader_loop(current_number + 1, caller, new_state)

      # Saves the prime numbers
      {:prime_result, number, is_prime, child_pid} ->
        acc = if is_prime do 
                [ number | state.primes ]
              else
                state.primes
              end
        
        new_state = Map.put(state, :primes, acc)

        # There are not more numbers to assign,
        # so it orders its child to terminate
        if current_number >= state.upper_bound do
          send(child_pid, {:finish})
          leader_loop(current_number, caller, new_state)
        else
          send(child_pid, {:is_prime, current_number})
          leader_loop(current_number + 1, caller, new_state)
        end
      
      # Waits to all its children to end the search
      {:delete_me, child_pid} ->
        # Deletes the child
        new_children = Enum.filter(state.children, fn child -> child != child_pid end)
        new_state = Map.put(state, :children, new_children)

        if length(new_state.children) == 0 do
          send(caller, {:ok, new_state.primes})
        else
          # Still waits its remaining children
          leader_loop(current_number, caller, new_state)
        end
    end
  end

  defp child(parent_pid) do
    spawn(fn ->
      # Registers itself as a child 
      send(parent_pid, {:parent, self()}) 
      child_loop(parent_pid)
    end)
  end

  defp child_loop(parent_pid) do
    receive do
      # Finds if a number is prime
      {:is_prime, number} ->
        is_prime = Algebra.is_prime?(number)
        send(parent_pid, {:prime_result, number, is_prime, self()})
        child_loop(parent_pid)

      # Process dies
      {:finish} ->
        send(parent_pid, {:delete_me, self()})
    end
  end

end