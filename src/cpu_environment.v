`timescale 1 ns / 10 ps

module cpu_environment(input wire clk, reset,
                       input wire [9:0] led_r, switches,
                       input wire [7:0] led_g,
                       input wire [3:0] buttons,
                       inout wire [15:0] data,
                       output wire [17:0] addresses,
                       output wire [4:0] control_mem );

  wire [7:0] interruptions;

  // instancia entrada salida
  i_o_manager in_out(clk, reset, addresses, data, buttons, switches, led_r, led_g, control_mem, interruptions);

  // instancia del procesador
  cpu cpumono(clk, reset, data, interruptions, addresses[15:0]);

  // timer
  timer timer_interrupt(clk, reset, interruptions);

endmodule
// quartus placa 484c7
// tools
// signaltag es algo de ultimo remedio