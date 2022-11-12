defmodule Roomie do
  def start(name, mailbox, roomie_mailbox, loaf) do
    spawn(fn ->
      algorithm(name, mailbox, roomie_mailbox, loaf)
    end)
  end

  defp algorithm(name, mailbox, roomie_mailbox, loaf) do
    hanging_around()
    IO.puts(["- ", name, " is coming home"])
    send(roomie_mailbox, {:add, :acquire1})
    {_, _, _, b2} = Mailbox.states(mailbox, roomie_mailbox)

    if b2 do
      send(roomie_mailbox, {:add, :acquire2})
    else
      send(roomie_mailbox, {:add, :release2})
    end

    IO.puts(["- ", name, " is waiting"])
    waiting_orders(mailbox, roomie_mailbox)
    IO.puts(["- ", name, " is approved"])

    send(loaf, {:bread?, self()})
    receive do
      {:bread?, bread?} ->
        if not bread? do
          IO.puts(["- ", name, " is buying more bread"])
          Process.sleep(2000)
          send(loaf, {:buy})
        end
    end

    send(roomie_mailbox, {:add, :release1})
    IO.puts(["- ", name, [" is leaving home"]])
    algorithm(name, mailbox, roomie_mailbox, loaf)
  end

  defp waiting_orders(mailbox, roomie_mailbox) do
    {_, a2, b1, b2} = Mailbox.states(mailbox, roomie_mailbox)
    if b1 and ((a2 and b2) or (not a2 and not b2)) do
      waiting_orders(mailbox, roomie_mailbox)
    end
  end

  defp hanging_around() do
    random_number = :rand.uniform(20)
    # up to 20 seconds
    Process.sleep(1000 * random_number)
  end
end
