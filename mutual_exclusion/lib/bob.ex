defmodule Alice do

    def start(idBuzonAlice,idPan) do
        spawn(fn -> loop(idAlice,idPan)
          end
        )
    end

    defp loopAlice(idBuzoAlice,idPan) do
        flag = false
        flag2 = false
        send(:acquire1,idAlice)

        receive do
          {:acquire1} -> send(idBuzonBob,:acquire1)

          {:acquire2} -> send(idBuzonBob,:acquire2)

          {:release1} -> send(idBuzonBob,:release1)


          {:release2} -> send(idBuzonBob,:release2)

        end

        if          do

        else

        end


       #Aqui va lo del While #

       #Aqui va lo del pan #

       send (idBuzonAlice, :realease1)

       loopAlice(idBuzonAlice,idPan)

end
