#!/bin/bash

echo "Compilando ensamblador..."
echo g++ -o ./ensamblador/ensamblador.out ./ensamblador/asm.cpp
g++ -o ./ensamblador/ensamblador.out ./ensamblador/asm.cpp

echo
echo "Ejecutando código ensamblador..."
echo ./ensamblador/ensamblador.out ./ensamblador/codigo.asm ./progfile.mem
./ensamblador/ensamblador.out ./ensamblador/codigo.asm ./progfile.mem

echo
echo "Probando test bench"
echo iverilog -o ./bin/cpu ./src/alu.v ./src/cd.v ./src/componentes.v ./src/cpu_tb.v ./src/cpu.v ./src/memprog.v ./src/pila.v ./src/uc.v
iverilog -o ./bin/cpu ./src/alu.v ./src/cd.v ./src/componentes.v ./src/cpu_tb.v ./src/cpu.v ./src/memprog.v ./src/pila.v ./src/uc.v

echo vvp ./bin/cpu
echo
vvp ./bin/cpu

if [ "$1" == "gtkwave" ]; then
    echo "Abriendo GTKWave..."
    echo gtkwave ./bin/cpu_tb.vcd
    gtkwave ./bin/cpu_tb.vcd
fi