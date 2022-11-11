defmodule Simulation do

  def start() do
   loaf = Loaf.start(20)
    {:ok, loaf}

   buzon_Alice = BuzonAlice.start()
   alice = Alice.start(buzon_bob, loaf)

  end

end
