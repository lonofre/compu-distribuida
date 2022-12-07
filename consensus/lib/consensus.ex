defmodule Consensus do
  def start(num_friends) do
    ids = 1..num_friends
        |> Enum.map(fn _ -> Friend.start() end)
    send_ids(ids, ids)
    IO.puts("Total participants:")
    IO.puts(num_friends)
    IO.puts("running ...\n")
    {alive, dead} = receive_from_children( [], [], num_friends)

    IO.puts("Participants who left:")
    IO.puts(length(dead))
    IO.puts("Participants who made a choice:")
    IO.puts(length(alive))

    choices = get_choices(alive)
    choices
    |> Enum.map(fn choice ->
      {movie, times} = choice
      IO.puts("- Movie " <> to_string(movie) 
        <> " was chosen " <> to_string(times) <> " times")
     end)

    if length(choices) == 1 do
      IO.puts("> Consensus reached!")
    else
      IO.puts("> No consensus was reached :(")
    end
  end

  def get_choices(alive) do
    alive
    |> List.foldr(%{}, 
      fn (data, acc) -> 
        {_, movie} = data

        case Map.fetch(acc, movie) do
          {:ok, value} -> Map.put(acc, movie, value + 1)
          :error -> Map.put(acc, movie, 1)
        end
      end)
    |> Map.to_list()
  end

  defp receive_from_children(alive, dead, total) do

    if (length(alive) + length(dead) == total) do
      {alive, dead}
    else
      receive do
        {:dead, friend} ->
          receive_from_children( alive, [friend | dead], total)
        {:choice, id,movie} ->
          receive_from_children( [ {id,movie} | alive], dead, total)
      end
    end
  end

  defp send_ids([], _) do
    {:ok, self()}
  end

  defp send_ids([id | xs], ids) do
    send(id, {:start, ids, self()})
    send_ids(xs, ids)
  end
end
