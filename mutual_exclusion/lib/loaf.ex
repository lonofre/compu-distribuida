defmodule Loaf do

  def start(slices) when slices > 0 do
    spawn(fn ->
        clock(self())
        loop(slices, slices)
      end
    )
  end

  defp loop(max_quantity, slices) do
    receive do
      {:reduce} ->
        if slices > 0 do
          loop(max_quantity, slices - 1)
        else
          loop(max_quantity, 0)
        end
      {:buy} ->
        if slices == 0 do
          loop(max_quantity, max_quantity)
        end
      {:bread?, roomie} ->
        response = slices > 0
        send(roomie, {:bread?, response})
    end
  end

  defp clock(pid) do
    spawn(fn -> clock_loop(pid) end)
  end

  defp clock_loop(pid) do
    # time in milliseconds
    Process.sleep(2000)
    send(pid, {:reduce})
    clock_loop(pid)
  end

end