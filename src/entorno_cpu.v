module entorno_cpu(input wire clk, reset);
  wire [15:0] direcciones, datos, botones, leds;
  wire [7:0] interrupcion;
  wire ce;

// instancia entrada salida
e_s entada_salida(clk, reset, direcciones, botones, datos, ce, leds);

// instancia del procesador
cpu cpumono(clk, reset, datos, interrupcion, direcciones);

// timer
timer contador(clk, reset, 8'd7, interrupcion);

endmodule
// quartus placa 484c7
// tools
// signaltag es algo de ultimo remedio