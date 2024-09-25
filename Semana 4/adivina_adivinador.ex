defmodule AdivinaAdivinador do
  @moduledoc """
  Implementación de un juego de Adivina-Adivinador utilizando procesos.

  La idea del juego Adivina_Adivinador es adivinar un numero basado en tres pistas, Caliente, Tibio y frio.

  Son dos funciones, una llamada "Adivinador", que guarda un número secreto entre 1 y 100, y otro llamado "Adivina", que trata de adivinarlo.
  "Adivinador" evalúa cada intento de "Adivina" y responde con :caliente, :tibio o :frio, según cuán cerca esté el número enviado.
  Si "Adivina" acierta el número, "Adivinador" termina el juego con un mensaje de victoria.
  El objetivo es que "Adivina" acierte el número mediante pistas graduales.
  """

  def start do

    numero_inicial = :rand.uniform(100)
    IO.puts("********** El número inicial es #{numero_inicial}  **********")
    id_process_adivinador = spawn(fn -> adivinador(numero_inicial) end)

    spawn(fn -> adivina(id_process_adivinador, true) end)
  end

  # Proceso Adivinador
  defp adivinador(numero_inicial) do
    receive do
      {:adivina, num, from} ->
        if num == numero_inicial do
          send(from, {:ganaste, num})
          IO.puts("***** Ganaste, el número era #{num} *****")
        else
          diferencia = abs(num - numero_inicial)

          cond do
            diferencia <= 10 ->
              IO.puts("++ Caliente!!!")
              send(from, {:caliente, num, self()})
            diferencia <= 20 ->
              IO.puts("++ Tibio!!")
              send(from, {:tibio, num, self()})
            true ->
              IO.puts("++ Frio!")
              send(from, {:frio, num, self()})
          end

          adivinador(numero_inicial)
        end
    end
  end

  # Proceso Adivina
  defp adivina(adivinador_pid, initial) do
    if initial do
      numero = :rand.uniform(100)
      send(adivinador_pid, {:adivina, numero, self()})
    end

    receive do
      {:ganaste, num} ->
        IO.puts("--Adiviné el número correcto: #{num}! El juego ha terminado.")

      {:caliente, num, _from} ->
        IO.puts("--El número es #{num}")
        nuevo_numero = :rand.uniform(21) + (num - 10)
        send(adivinador_pid, {:adivina, nuevo_numero, self()})

      {:tibio, num, _from} ->
        IO.puts("--El número es #{num}")
        nuevo_numero = :rand.uniform(41) + (num - 20)
        send(adivinador_pid, {:adivina, nuevo_numero, self()})

      {:frio, num, _from} ->
        IO.puts("--El número es #{num}")
        rango =
          if :rand.uniform(2) == 1 do
            0..(num - 21)
          else
            (num + 21)..100
          end
        nuevo_numero = Enum.random(rango)
        send(adivinador_pid, {:adivina, nuevo_numero, self()})
    end

    adivina(adivinador_pid, false)
  end
end

# Para iniciar el juego
# AdivinaAdivinador.start()
