# Algoritmo de multiplicación de Booth de N bits con recodificación a N bits.
Se ha implementado 

## Implementación



## Funcionamiento básico de Verilog

- Para compilar:
```terminal
  $ iverilog -o cpu alu.v cd.v componentes.v cpu_tb.v cpu.v memprog.v pila.v uc.v
```

- Para simulación rápida
```terminal
  $ vvp cpu
```

- Para simular con el GTKWave:
```terminal
  $ gtkwave cpu_tb.vcd
```


## Funcionamiento básico de GTKWave
Una vez abierto es necesario darle a reload para que se "ponga en marcha".

Luego vamos arrastrando las señales que queramos visualizar.

## Resultados
Deberían ser todos CORRECTO para dar por bueno el algoritmo.
