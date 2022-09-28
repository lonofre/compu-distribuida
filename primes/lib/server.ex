defmodule Server do
    def start(n_workers, upper_bound) do
      block = div(upper_bound, n_workers)

      0..(n_workers - 1)
      |> Enum.to_list()
      |> Enum.map(fn wid ->
        Worker.start(wid * block + 1, min((wid + 1) * block, upper_bound)) end)
      |> Enum.map(fn _ -> Worker.get_result() end)
      |> Enum.concat()
      |> Enum.sort()
      |> IO.inspect()
    end
end