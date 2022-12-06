defmodule Consensus do
  def start(friends) do
    ids = 1..friends
        |> Enum.map(fn _ -> Friend.start() end)
    send_ids(ids, ids)
    procesos = length(ids)
    IO.puts("Cantidad de procesos que participaron :")
    IO.puts(procesos)
    {alive,deaths} = receive_from_children([],[],procesos)
    muertos = length(deaths)
    vivos = length(alive)
    IO.puts("Cantidad de procesos que murieron :")
    IO.puts(muertos)
    IO.puts("Procesos que sobrevivieron :")
    IO.puts(vivos)
    print_choices(alive)

  end

  defp print_choices ([]) do {:ok} end
  defp print_choices([x|xs]) do
     {id,movie} = x
     IO.puts("Elecciones por proceso")
     IO.inspect(x)
     print_choices(xs)
  end

  defp receive_from_children(alive, dead,nProceso) do
    len  = length(dead)
    if (length(alive) + len == nProceso) do
      {alive, dead}
    else
      receive do
        {:muerto, friend} ->
          receive_from_children(alive, [friend | dead],nProceso)
        {:choice,id,movie} ->
          receive_from_children([{id,movie}|alive],dead,nProceso)
      end
    end
  end

  defp send_ids([], ids) do
    {:ok, self()}
  end

  defp send_ids([id | xs], ids) do
    send(id, {:start, ids, self()})
    send_ids(xs, ids)
  end
end
