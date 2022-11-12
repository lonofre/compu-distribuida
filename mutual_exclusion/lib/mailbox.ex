defmodule Mailbox do
  
  @doc """
  Starts a mailbox that stores the messages 
  between processes
  """
  def start() do
    spawn(fn -> loop([]) end)
  end

  defp loop(messages) do
    receive do
      {:get_messages, id} ->
        send(id, {:messages, messages})
        loop(messages)
      {:empty} ->
        loop([])
      {:add, message} ->
        loop([message | messages])
    end  
  end

  defp acq1(messages) do
    case messages do
      [] -> false
      [x | xs ] ->
        case x do
          :release1 -> false
          :adquire1 -> true
          _ -> 
            acq1(xs)
        end
    end
  end

  defp acq2(messages) do
    case messages do
      [] -> false
      [x | xs ] ->
        case x do
          :release2 -> false
          :adquir2 -> true
          _ -> acq2(xs)
        end
    end
  end

  defp get_messages(mailbox) do
    send(mailbox, {:get_messages, self()})
    receive do
      {:messages, messages} -> messages
    end
  end

  def states(mailbox, roomie_mailbox) do
    own_messages = get_messages(mailbox)
    roomie_messages = get_messages(roomie_mailbox)
    a1 = acq1(own_messages)
    a2 = acq2(own_messages)
    b1 = acq1(roomie_messages)
    b2 = acq2(roomie_messages)
    {a1, a2, b1, b2}
  end

end
