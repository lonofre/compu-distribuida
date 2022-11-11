defmodule Simulation do

  def start() do
   loaf = Loaf.start(20)
    {:ok, loaf}

   buzon_Alice = BuzonAlice.start()
   buzon_Bob = BuzonBob.start()
   alice = Alice.start(buzon_bob,buzon_Alice, loaf)

  end

end
