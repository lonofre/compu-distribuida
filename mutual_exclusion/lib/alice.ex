defmodule Alice do

    def start(buzon_bob,buzon_Alice, loaf) do
        spawn(fn -> alice(buzon_bob,buzon_Alice, loaf)
          end
        )
    end

    def acquire1_no_release1(mensajes) do
      case mensajes do
        [] ->
          false

        [{:release_1} | _xs] ->
          false

        [{:acquire_1} | _xs] ->
          true

        [_x | xs] ->
          acquire1_no_release1(xs)
      end
    end

    def acquire2_no_release2(mensajes) do
      case mensajes do
        [] ->
          false


        [{:release_2} | _xs] ->
          false

        [{:acquire_2} | _xs] ->
          true

        [_x | xs] ->
          acquire2_no_release2(xs)
      end
    end


    defp loop_alice(buzon_alice_id, buzon_bob_id) do
      {_a1, a2, b1, b2} = get_states(buzon_alice_id, buzon_bob_id)

      if b1 and ((a2 and b2) or (not a2 and not b2)) do
        loop_alice(buzon_alice_id, buzon_bob_id)
      end
    end

    def alice(pan_id, buzon_alice_id, buzon_bob_id) do
      IO.puts("------------------------")
      IO.puts("Alice llego a casa .... ")
      IO.puts("------------------------")

      send(buzon_bob_id, {:acquire_1})
      {_a1, _a2, _b1, b2} = get_states(buzon_alice_id, buzon_bob_id)

      if b2 do
        send(buzon_bob_id, {:acquire_2})
      else
        send(buzon_bob_id, {:release_2})
      end

      loop_alice(buzon_alice_id, buzon_bob_id)

      # Final del algoritmo (se revisa si hay pan)
      if not Pan.hay_pan(pan_id) do
        IO.puts("------------------------")
        IO.puts("Alice ha salido a comprar pan .... ")
        IO.puts("------------------------")
        :timer.sleep(SiTenemosPan.get_compra_delay())
        Pan.comprar_pan(pan_id, "Alice")
      end

      send(buzon_bob_id, {:release_1})

      # Simula que regresa a revisar el pan después de un tiempo
      delay = SiTenemosPan.get_consulta_delay()
      IO.puts("Alice se irá durante #{delay / 1000}s")

      :timer.send_after(
        delay,
        self(),
        {:start}
      )

     alice(pan_id, buzon_alice_id, buzon_bob_id)
    end

end
