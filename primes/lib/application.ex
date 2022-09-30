defmodule Primes.Application do

    use Application

    @n_workers 4
    @upper_bound 10000
    @file_name "primes.txt"

    def start(_, _) do
        {:ok, spawn(fn -> 
            Server.dispenser_primes_finder(@n_workers, @upper_bound) |> write_primes(@file_name)
        end)}
    end

    defp write_primes(primes, file_name) do
        IO.puts(file_name)
        lines = primes |> Enum.map(fn n -> Integer.to_string(n) end)
        content = Enum.join(lines, "\n")
        File.write(file_name, content)
    end

end