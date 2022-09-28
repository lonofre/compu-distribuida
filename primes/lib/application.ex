defmodule Primes.Application do

    use Application

    @n_workers 4
    @upper_bound 300

    def start(_, _) do
        {:ok, spawn(fn -> Server.start(@n_workers, @upper_bound) end)}
    end

end