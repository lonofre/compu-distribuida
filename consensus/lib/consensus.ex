defmodule Consensus do
  def start(friends) do

    ids = 1..friends
        |> Enum.map(fn _ -> Friend.start() end)

    send_ids(ids, ids)

  end

  defp send_ids([], ids) do
    {:ok, self()}
  end

  defp send_ids([id | xs], ids) do
    send(id, {:start, ids, self()})
    send_ids(xs, ids)
  end

end
