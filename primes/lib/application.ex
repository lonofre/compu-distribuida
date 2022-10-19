defmodule Primes.Application do

  use Application

  @n_workers 4
  @upper_bound 10000
  @file_name "primes.txt"

  def start(_, _) do
  
    {parsed, _, _} = OptionParser.parse(System.argv(), strict: [mode: :string, workers: :integer, bound: :integer])

    upper_bound = parsed[:bound] || @upper_bound
    n_workers = parsed[:workers] || @n_workers
    mode = parsed[:mode] || "dispenser"
  
    {:ok, spawn(fn -> 
      case mode do
        "range" -> RangePrimesFinder.start(n_workers, upper_bound) |> write_primes(@file_name)
        "dispenser" -> DispenserPrimesFinder.start(n_workers, upper_bound) |> write_primes(@file_name)
      end
    end)}
  end

  defp write_primes(primes, file_name) do
    lines = primes |> Enum.map(fn n -> Integer.to_string(n) end)
    content = Enum.join(lines, "\n")
    File.write(file_name, content)
  end

end