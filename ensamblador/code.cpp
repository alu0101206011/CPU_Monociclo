#include <iostream>

const unsigned TAM_MEM = 1000000000;
const unsigned NUM_DEVICES = 16;

// reseteas el indice en el modo captura
// mejor empezar a capturar 
// el modo reproducción muestra lo que hay en la memoria de captura
// en el modo captura mostrar un destello cada vez que capturas

//https://stackoverflow.com/questions/12904098/c-implementing-timed-callback-function


void subrutina(char modo, int *mem, int* green_leds_out, unsigned *cont) {
  if (modo = 'c') {
    mem[*cont % TAM_MEM] = rand();
    *cont++;
    green_leds_out[*cont % NUM_DEVICES] = 1;
  }
  else if (modo = 'r') {
    std::cout << "Dato " << *cont << ": " << green_leds_out[*cont % NUM_DEVICES] << "\n";
    *cont++;
  }
}

bool timer(void) {
  for (int i = 0; i < 1000000000; i++);
  return true;
}


int main(int argc, char* argv[]) {

  int *leds_in, *red_leds_out, *green_leds_out, *buttons, sensor, *mem;
  leds_in = new int[NUM_DEVICES];
  green_leds_out = new int[NUM_DEVICES];
  red_leds_out = new int[NUM_DEVICES];
  buttons = new int[NUM_DEVICES];
  mem = new int[TAM_MEM];
  char modo;

  unsigned cont;

  while(true) {
    if (buttons[0]) {
      red_leds_out[0] = 1;
    }
    if (buttons[1]) {
      modo = 'c';
      cont = 0;
    } else if (buttons[2]) {
      modo = 'r';
      cont = 0;
    }
    if (timer()) {
      subrutina(modo, mem, green_leds_out, &cont);
    }
  }
  for (int i = 0; i < NUM_DEVICES; i++) buttons[i] = 0;
  return 0;
}

// necesito llevar la entrada salida por el timer, el timer lleva a cada rato la subrutina