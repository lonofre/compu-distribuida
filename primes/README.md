# Cálculo de números primos

Calculos los números primos usando diferentes técnicas:
- Criba de Eratóstenes, usando un sólo proceso.
- Usando `n` procesos con rangos fijos.
- Usando `n` procesos coordinados por otro, de tal modo que un proceso al terminar su trabajo, se le asigna otro.

## Cómo ejecutar 🚀🚀

Primero se compila:
```bash
mix compile
```
Después, para ejecutar todo el proyecto:
```bash
mix run --no-halt --mode [MODE] --bound [BOUND] --workers [WORKERS]
```
donde:
- `MODE` es `sieve` para usar la Criba de Eratóstenes, `range` para usar procesos con rangos iguales y `dispenser` para usar un proceso extra que coordine a todos los procesos.
- `BOUND` hasta que cota superior se van a buscar los números primos.
- `WORKERS` es el número de procesos que se encargan de procesar los números primos. Sólo para los modos `range` y `dispenser`. 

El resultado es un archivo `primes.txt` con los números primos.