`timescale 1 ns / 10 ps

module cpu_environment(input wire clk, reset,
                       input wire [9:0] led_r, switches,
                       input wire [7:0] led_g,
                       input wire [3:0] buttons,
                       output wire [17:0] addresses,
                       output wire [4:0] control_mem,
                       inout wire [15:0] data);

  wire [7:0] interruption_timer, interruptions_io, interruptions;
  wire oe;

  // instancia entrada salida
  i_o_manager in_out(clk, reset, oe, addresses, buttons, switches, led_r, led_g, control_mem, interruptions, data);

  // instancia del procesador
  cpu cpumono(clk, reset, interruptions, oe, addresses[15:0], data);

  // timer
  timer timer_interrupt(clk, reset, interruption_timer);

  assign interruptions = interruption_timer | interruptions_io;

endmodule
// quartus placa 484c7
// tools
// signaltag es algo de ultimo remedio