defmodule Algebra do
  
  @doc """
  Finds if a number is prime using the Sieve of Erastosthenes
  """
  def is_prime?(1), do: false 
  def is_prime?(n) when n > 1 do
    n == List.last(primes_to(n))
  end

  @doc """
  Finds if a number is prime by dividing from its root to 1
  """
  def is_prime2?(1), do: false
  def is_prime2?(n) when n > 1 do
    if rem(n, 2) == 0 && n != 2 do
      false
    else
      root = :math.sqrt(n) |> trunc()
      divider = if rem(root, 2) == 0 do
          root - 1
        else 
          root
        end
      is_prime_dummy?(n, divider)
    end
  end

  defp is_prime_dummy?(_, 1), do: true

  defp is_prime_dummy?(n, divider) do
    if rem(n, divider) == 0 do
      false
    else
      is_prime_dummy?(n, divider - 2)
    end
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