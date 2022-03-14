#!/bin/bash

# Variables
DEEBUG_ON=0
ASSEMBLY=./ensamblador/asm.cpp
EXECUTABLE=./ensamblador/ensamblador.out
MEMORY=./progfile.mem
ASSEMBLY_CODE=./ensamblador/codigo.asm
GTKWAVE=0
VERILOG_CODE=$(ls -d ./src/*)
VERILOG_EXECUTABLE=./bin/cpu
GTKWAVE_EXECUTABLE=./bin/cpu_tb.vcd

# Funciones

exit_error() {
  echo "$1" 1>&2
  usage
  exit 1
}


usage() {
  echo "usage: ejecutar.sh [-d] [-g] [-h] [-ac codigo]"
  echo -e "\n\tComando -d o --debug Ejecuta en el ejectuable asm para debugear el código ensamblador en vscode. 
\tComando -g o --gtkwave ejecuta el GTKWave. 
\tComando -h o --help muesta esta ayuda. 
\tCommando -ac o --assembly_code [file] Ejecuta el código que haya en ensamblador"

}

#Realizamos case
#Usamos while para poder poner varias opciones en la linea de comandos

while [ "$1" != "" ]; do
  case $1 in
    -h | --help )
      usage
      exit 0
      ;;

    -d | --debug )
      EXECUTABLE=./ensamblador/asm
      ;;

    -g | --gtkwave )
      GTKWAVE=1
      ;;

    -ac | --assembly_code )
      shift
      if [[ "$1" != "" && "$1" != -* ]]; then
        ASSEMBLY_CODE=./ensamblador/$1
      else
        exit_error "Faltan argumentos."
      fi
      ;;
    * )
      exit_error "La opcion $1 no existe, por favor indique una opcion valida."
      ;;
  esac
  shift
done     

echo "Compilando ensamblador..."
echo g++ -o $EXECUTABLE $ASSEMBLY
g++ -o $EXECUTABLE $ASSEMBLY

echo
echo "Ejecutando código ensamblador..."
echo $EXECUTABLE $ASSEMBLY_CODE $MEMORY
$EXECUTABLE $ASSEMBLY_CODE $MEMORY

echo
echo "Probando test bench"
echo iverilog -o $VERILOG_EXECUTABLE $VERILOG_CODE
iverilog -o $VERILOG_EXECUTABLE $VERILOG_CODE
echo vvp $VERILOG_EXECUTABLE 
echo
vvp $VERILOG_EXECUTABLE | grep -v "VCD warning: array word cpu_tb.cpumono.camino_datos.banco_registros"

if [ $GTKWAVE == 1 ]; then
  echo
  echo "Abriendo GTKWave..."
  echo gtkwave $GTKWAVE_EXECUTABLE
  gtkwave $GTKWAVE_EXECUTABLE
fi