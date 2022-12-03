defmodule Consensus do

  def start(folks) do

    ids = [1..folks]
        | Enum.map(fn x -> PoolParty.start())

    send_ids(ids, ids)

  end



  def send_ids([id:xs], ids) do
    send(id, {:start, ids})
    send_ids(xs, ids)
  end

end


defmodule PoolParty do

  def start() do
    spawn(fn -> wait_for_start() end)
  end

  def wait_for_start() do
    receive do
      {:start, folks} ->
        movie = elegir_pelicula()
        ronda = 0
        choose_movie(folks, movie, ronda)
    end
  end

  def chose_movie(folks,movie,ronda) do
     ronda = ronda + 1
     se_muerte = se_muere?()
    if se_muerte do
        hasta =  hasta_que_amigo_le_envia(longitud(folks))
        funcion_muerte(hasta, folks)
    else
      amies.Enum.Map(fn amigo -> send(folks, {:movie, movie}))
    end

    eleccion = min(mensajero(bandeja))
    if folks == ronda + 1 do
      movie
    else
      chose_movie(folks,eleccion,ronda)
    end


  end

  def mensajero(bandeja) do

    receive do
      {:movie,movie} ->
        mensajero([movie|bandeja])
    after
      #Despues de 8 se segundos#
      bandeja
  end

  def funcion_muerte(hasta, amigos, movie) do
    amies = take(hasta, amigos)
    amies.Enum.Map(fn amigo -> send(amigo, {:movie, movie}))
  end

end
