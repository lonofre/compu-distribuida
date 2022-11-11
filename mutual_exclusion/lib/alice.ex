defmodule Alice do

    def start(idBuzonBob,idPan) do
        spawn(fn -> loop(idBob,idPan)
          end
        )
    end

    defp loopAlice(idBuzonBob,idPan) do
        flag = false
        flag2 = false
        send(:acquire1,idBob)

        receive do
          {:acquire1} -> send(idBuzonBob,:acquire1)

          {:acquire12} -> send(idBuzonBob,:acquire2)

          {:release1} -> send(idBuzonBob,:release1)


          {:release2} -> send(idBuzonBob,:release2)

        end

        if          do

        else

        end


       #Aqui va lo del While #

       #Aqui va lo del pan #

       send (idBuzonBob, :realease1)

       loopAlice(idBuzonBob,idPan)

end
