`timescale 1 ns / 10 ps

module entorno_cpu(input wire clk, reset, 
                   input wire [9:0] led_r, switches,
                   input wire [7:0] led_g, 
                   input wire [3:0] botones,
                   inout wire [15:0] datos,
                   output wire [17:0] direcciones,
                   output wire [4:0] control_mem );

  wire [7:0] interrupcion;

  // instancia entrada salida
  gestor_e_s entada_salida(clk, reset, direcciones, datos, botones, switches, led_r, led_g, control_mem, interrupcion);

  // instancia del procesador
  cpu cpumono(clk, reset, datos, interrupcion, direcciones[15:0]);

  // timer
  timer contador(clk, reset, interrupcion);

endmodule
// quartus placa 484c7
// tools
// signaltag es algo de ultimo remedio