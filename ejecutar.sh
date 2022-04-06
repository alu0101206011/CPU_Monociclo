#!/bin/bash

# Variables
ASSEMBLY_CODE_SOURCE=./ensamblador
VERILOG_CODE_SOURCE=./src
EXECUTABLE_SOURCE=./bin
MEMORY=./progfile.mem

ASSEMBLY=$ASSEMBLY_CODE_SOURCE/asm.cpp
EXECUTABLE=$ASSEMBLY_CODE_SOURCE/ensamblador.out
EXECUTABLE_DEBUG=$ASSEMBLY_CODE_SOURCE/asm
ASSEMBLY_CODE=$ASSEMBLY_CODE_SOURCE/codigo.asm
VERILOG_WALL=
VERILOG_CODE=$(ls $VERILOG_CODE_SOURCE/* | grep -v _tb.v)
TEST_BENCH=$VERILOG_CODE_SOURCE/cpu_tb.v
VERILOG_EXECUTABLE=$EXECUTABLE_SOURCE/cpu
GTKWAVE=0
GTKWAVE_EXECUTABLE=$EXECUTABLE_SOURCE/cpu_tb.vcd
DEBUG_ON=0

# Funciones

exit_error() {
  echo "---------  $1  ---------" 1>&2
  echo
  usage
  exit 1
}


usage() {
  echo "usage: ejecutar.sh [-d] [-g] [-ac fichero] [-t fichero] [-w] [-h]"
  echo -e "\n\tComando -d o --debug Ejecuta en el ejectuable asm para debugear el código ensamblador en vscode. 
\tComando -g o --gtkwave ejecuta el GTKWave. 
\tComando -ac o --assembly_code [fichero] Ejecutamos el programa con el fichero indicado por línea de comandos escrito en ensamblador.
\tComando -t o --testbench [fichero] Ejecutamos el test bench indicado por línea de comandos.
\tComando -w o --Wall Compila verilog enseñando todos los warnings.
\tComando -h o --help muesta esta ayuda.\n"
}

# Para cambiarte de directorio al del script
pushd "$(dirname ${BASH_SOURCE:0})" > /dev/null 2>&1
popd > /dev/null 2>&1


# Usamos while para poder poner varias opciones en la linea de comandos

while [ "$1" != "" ]; do
  case $1 in
    -h | --help )
      usage
      exit 0
      ;;

    -d | --debug )
      EXECUTABLE=$EXECUTABLE_DEBUG
      ;;

    -g | --gtkwave )
      GTKWAVE=1
      ;;

    -ac | --assembly_code )
      shift
      if [[ "$1" != "" && "$1" != -* ]]; then
        ASSEMBLY_CODE=$ASSEMBLY_CODE_SOURCE/$1
      else
        exit_error "Faltan argumentos"
      fi
      ;;
    -w | --Wall )
      VERILOG_WALL="-Wall"
      ;;
    -t | --testbench )
      shift
      if [[ "$1" != "" && "$1" != -* ]]; then
        TEST_BENCH=$VERILOG_CODE_SOURCE/$1
      else
        exit_error "Faltan argumentos"
      fi
      ;;
    * )
      exit_error "La opción $1 no existe, por favor indique una opción válida"
      ;;
  esac
  shift
done     

echo "Compilando ensamblador..."
echo g++ -o $EXECUTABLE $ASSEMBLY
if g++ -o $EXECUTABLE $ASSEMBLY; then 
  echo
  echo "Ejecutando código ensamblador..."
  echo $EXECUTABLE $ASSEMBLY_CODE $MEMORY
  $EXECUTABLE $ASSEMBLY_CODE $MEMORY

  echo
  echo "Probando test bench"
  echo iverilog -o $VERILOG_EXECUTABLE $VERILOG_WALL $VERILOG_CODE $TEST_BENCH
  if iverilog -o $VERILOG_EXECUTABLE $VERILOG_WALL $VERILOG_CODE $TEST_BENCH; then 
    echo vvp $VERILOG_EXECUTABLE 
    echo
    vvp $VERILOG_EXECUTABLE | grep -v "VCD warning: array word"
  fi
fi
if [ $GTKWAVE == 1 ]; then
  echo
  echo "Abriendo GTKWave..."
  echo gtkwave $GTKWAVE_EXECUTABLE
  gtkwave $GTKWAVE_EXECUTABLE
fi