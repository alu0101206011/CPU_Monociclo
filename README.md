# Diseño de procesadores 2021-2022 Implementacion de una CPU monociclo

## Objetivo
El objetivo de esta práctica es desarrollar una CPU básica monociclo. Esta CPU en concreto es la CPU "avanzada" la cual posee las siguientes características:

- Tiene un tamaño de palabra de 32 bits.
- Posee una memoria de programa con un máximo de 1024 instrucciones.
- Una pila para subrutinas con control de overflow y underflow.
- Operaciones aritmetico-lógicas con registros.
- Operaciones aritmetico-lógicas inmediatas
- Salto absoluto, salto si cero, salto si no cero y relativo.
- Modo de direcionamiento inmediato, directo y relativo.
- Gestión jerarquica de interrupciones


## Manejo básico
Estando desde el espacio de trabajo ejecutamos
```
./ejecutar.sh
```

Gracias a esto compilaremos el código ensamblador en c++, lo ejecutaremos con
un archivo pasado como parametro al main por defecto, se compilará verilog y 
se ejecutará una simulación.

Si quiere saber todas las opciones ejecute en terminal:
```
./ejecutar.sh -h  

    ó

./ejecutar.sh --help
```

## Diseño de la CPU

Este es el actual diseño de conexiones de la CPU.

![Dibujo conexiones CPU](./img/conexion_cpu.png)


## Codificación de instrucciones
### Aritmetico-lógicas registros
![Codificación de instrucciones aritmetico-lógicas por registros](./img/cod_arit_reg.png)
| Instrucción       | OPCODE    | Descripción               |
| :-----------:     | :-------: |---------------------------|
| **ALU (R1))**     | 1000      | Carga                     |
| **ALU (~R1)**     | 1001      | Complemento a 1           |
| **ALU (R1+R2)**   | 1010      | Suma                      |
| **ALU (R1-R2)**   | 1011      | Resta                     |
| **ALU (R1&R2)**   | 1100      | AND                       |
| **ALU (R1\|R2)**  | 1101      | OR                        |
| **ALU (-R1)**     | 1110      | Complemento a 2           |
| **ALU (-R2)**     | 1111      | Complemento a 2           |

### Aritmetico lógicas inmediatas
![Codificación de instrucciones aritmetico-lógicas inmediatas](./img/cod_arit_inm.png)
| Instrucción       | OPCODE    | Descripción               |
| :---------------: | :-------: |---------------------------|
| **ALU (inm)**     | 00010000  | Carga                     |
| **ALU (~inm)**    | 00010001  | Complemento a 1           |
| **ALU (inm+b)**   | 00010010  | Suma                      |
| **ALU (b-inm)**   | 00010011  | Resta                     |
| **ALU (inm&b)**   | 00010100  | AND                       |
| **ALU (inm\|b)**  | 00010101  | OR                        |
| **ALU (-inm)**    | 00010110  | Complemento a 2           |
| **ALU (-inm)**    | 00010111  | Complemento a 2           |


### Memoria
![Codificación de la instruccion load](./img/cod_load.png)
![Codificación de la instruccion loadr](./img/cod_loadr.png)
![Codificación de la instrucción store](./img/cod_store.png)
![Codificación de la instrucción store](./img/cod_storer.png)

| Instrucción   | OPCODE    | Descripción                                                                           |
| :-----------: | :-------: |---------------------------------------------------------------------------------------|
| **STORE**     | 0000      | Carga en memoria                                                                      |
| **STORER**    | 0010      | Carga en memoria relativa a registro (si el inmediato es 0 es directo por registro)   |
| **LOAD**      | 0011      | Carga de memoria                                                                      |
| **LOADR**     | 0011      | Carga de relativa a registro (si el inmediato es 0 es directo por registro)           |

### Saltos
![Codificación de instrucciones de salto absoluto](./img/cod_j.png)
![Codificación de instrucciones de salto relativo](./img/cod_jr.png)
| Instrucción   | OPCODE    | Descripción               |
| :-----------: | :-------: |---------------------------|
| **j**         | 00011000  | Salto absoluto            |
| **jr**        | 00011001  | Salto relativo            |
| **jz**        | 00011010  | Salto relativo si cero    |
| **jnz**       | 00011011  | Salto relativo si no cero |
| **jne**       | 00011100  | Salto relativo si no cero |
| **jcall**     | 0101      | Salto relativo a subrutina|
| **jret**      | 0110      | Retorno de subrutina      |
| **reti**      | 00011101  | Retorno de interrupción   |

### Resto de instrucciones
| Instrucción   | OPCODE    | Descripción               |
| :-----------: | :-------: |---------------------------|
| **nop**       | 00011111  | Instrucción vacía         |


## Biestables

### Biestables en las interrupciones
Necesitamos biestables que trabajen cuando estamos en una interrupción porque necesitamos mantener
el valor de los biestables del programa de ejecución normal de la CPU por si hay una interrupción
justo cuando vamos a decidir un salto.

Además no sería bueno limitarnos los saltos en las interrupciones en si. Por esta razón nacieron
los biestables de salto en las interrupciones.