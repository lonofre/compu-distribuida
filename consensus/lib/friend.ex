defmodule Friend do

  def start() do
    spawn(fn -> wait_for_start() end)
  end

  defp wait_for_start() do
    receive do
      {:start, friends, parent} ->
        movie = select_movie(1000)
        round = 0
        choose_movie(parent, friends, movie, round)
    end
  end

  defp select_movie(limit) do
    :rand.uniform(limit)
  end

  defp choose_movie(parent, friends, movie, round) do
    IO.puts(round)
     round = round + 1
     is_dead? = is_dead?()
    if is_dead? do
        until = :rand.uniform(length(friends))
        kill(until, friends, movie)
    else
      friends
      |> Enum.map(fn friend -> send(friend, {:movie, movie}) end)
    end
    IO.puts(round)


    choice = minim(receive_movie([]))
    IO.puts("a")

    if length(friends) == round + 1 do
      send(parent, {:choice, self(), movie})
      IO.puts(movie)
    else
      choose_movie(parent, friends, choice, round)
    end
  end

  defp is_dead?() do
    random = :rand.uniform(100)
    if rem(random, 10) == 0 do
      true
    else
      false
    end

  end

  defp receive_movie(mail) do
    receive do
      {:movie, movie} ->
        receive_movie([movie|mail])
    after
      8_000 ->
        #Despues de 8 se segundos#
        IO.puts("hola")
        mail
    end
  end

  defp kill(round, friends, movie) do
    Enum.take(friends, round)
      |> Enum.map(fn friend -> send(friend, {:movie, movie}) end)
  end

  defp minim([]) do 0 end
  defp minim([x | []]) do x end
  defp minim([x| xs] ) do min(x, minim(xs)) end

end
