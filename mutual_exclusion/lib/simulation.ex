defmodule Simulation do

  def start() do
    loaf = Loaf.start(20)
    
    alice_mailbox = Mailbox.start()
    bob_mailbox = Mailbox.start()

    Roomie.start("Alice", alice_mailbox, bob_mailbox, loaf)
    Roomie.start("Bob", bob_mailbox, alice_mailbox, loaf)

    {:ok, self()}
  end

end
