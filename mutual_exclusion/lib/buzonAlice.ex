def start() do
  spawn(fn -> acumulador([])
    end
  )
end

def acumulador (mensajes) do
  receive do
      {:obtener_mensajes , id} ->
          send (id,{:mensajes , mensajes})
          buzon([])
      m ->
          buzon([m|mensajes])
end

def get_mensajes_buzon (buzon_id) do

  send(buzon_id,{:obtener_mensajes,self()})

  receive do
      {:mensajes, ms} ->
          ms
  end
