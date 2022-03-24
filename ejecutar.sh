#!/bin/bash

# Variables
DEBUG_ON=0
ASSEMBLY=./ensamblador/asm.cpp
EXECUTABLE=./ensamblador/ensamblador.out
MEMORY=./progfile.mem
ASSEMBLY_CODE=./ensamblador/codigo.asm
GTKWAVE=0
VERILOG_ALL=
VERILOG_CODE=$(ls ./src/*)
VERILOG_EXECUTABLE=./bin/cpu
GTKWAVE_EXECUTABLE=./bin/cpu_tb.vcd

# Funciones

exit_error() {
  echo "---------  $1  ---------" 1>&2
  echo
  usage
  exit 1
}


usage() {
  echo "usage: ejecutar.sh [-d] [-g] [-h] [-ac codigo] [-w]"
  echo -e "\n\tComando -d o --debug Ejecuta en el ejectuable asm para debugear el código ensamblador en vscode. 
\tComando -g o --gtkwave ejecuta el GTKWave. 
\tComando -h o --help muesta esta ayuda. 
\tComando -ac o --assembly_code [file] Ejecutamos el programa con el fichero indicado escrito en ensamblador.
\tComando -w o --Wall Compila verilog enseñando todos los warnings."
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
        exit_error "Faltan argumentos"
      fi
      ;;
    -w | --Wall )
      VERILOG_ALL="-Wall"
      ;;
    * )
      exit_error "La opción $1 no existe, por favor indique una opción válida"
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
echo iverilog -o $VERILOG_EXECUTABLE $VERILOG_ALL $VERILOG_CODE
if iverilog -o $VERILOG_EXECUTABLE $VERILOG_ALL $VERILOG_CODE; then 
  echo vvp $VERILOG_EXECUTABLE 
  echo
  vvp $VERILOG_EXECUTABLE | grep -v "VCD warning: array word cpu_tb.cpumono.camino_datos.banco_registros"
fi
if [ $GTKWAVE == 1 ]; then
  echo
  echo "Abriendo GTKWave..."
  echo gtkwave $GTKWAVE_EXECUTABLE
  gtkwave $GTKWAVE_EXECUTABLE
fi