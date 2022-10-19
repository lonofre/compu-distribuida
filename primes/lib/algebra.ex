defmodule Algebra do
  
  @doc """
  Finds if a number is prime using the Sieve of Erastosthenes
  """
  def is_prime?(1), do: false 
  def is_prime?(n) when n > 1 do
    n == List.last(primes_to(n))
  end

  @doc """
  Finds all primes given a limit
  """
  def primes_to(n) do
    do_primes(Enum.to_list(1..n) )
  end

  # Sieve of Eratosthenes
  defp do_primes( [] ), do: []
  defp do_primes( [1 | xs] ), do: do_primes(xs)
  defp do_primes( [prime | _] = sieve ) do
    sieve =
      sieve
      |> Enum.filter(fn n -> rem(n, prime) != 0 end)

    [prime | do_primes(sieve)]
  end
  
end