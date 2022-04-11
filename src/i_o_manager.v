`timescale 1 ns / 10 ps

module i_o_manager(input wire clk, reset, oe, 
                   input wire [17:0] addr,
                   input wire [3:0] buttons,
                   input wire [9:0] switches,
                   output wire [9:0] led_r,
                   output wire [7:0] led_g,
                   output wire [4:0] control_mem, // we ce oe lb ub
                   output reg [7:0] interruptions,
                   inout wire [15:0] data);

  wire wr, wg;

  wire [9:0] filter_r, lr;
  wire [7:0] filter_g, lg;
  assign filter_r = lr ^ data[9:0];
  assign filter_g = lg ^ data[7:0];

  register #(10) leds_red(clk, reset, wr, filter_r, lr);
  register #(8) leds_green(clk, reset, wg, filter_g, lg);

  assign led_r = ~lr;
  assign led_g = ~lg;

  initial
  begin
    interruptions <= 8'b0;
  end

  reg [6:0] control;
  assign {wr, wg, control_mem} = control;

  parameter LED_RED = 7'b10x1xxx;
  parameter LED_GREEN = 7'b01x1xxx;
  parameter NOP = 7'b00x1xxx;
  parameter MEMORY_STORE = 7'b0000x00;
  parameter MEMORY_LOAD = 7'b0010000;

  always @(*)
  begin
    case (buttons) // presionas un botón
      4'b0001: interruptions = 8'b01000000 | interruptions;
      4'b0010: interruptions = 8'b00100000 | interruptions;
      4'b0100: interruptions = 8'b00010000 | interruptions;
      4'b1000: interruptions = 8'b00001000 | interruptions;
      default: interruptions = 8'b00000000;
    endcase

    case (addr[15:0]) // para escribir en leds
      16'b1111111111111110: control <= oe ? LED_RED : NOP;
      16'b1111111111111111: control <= oe ? LED_GREEN : NOP;
      default: control <= oe ? MEMORY_STORE : MEMORY_LOAD;
    endcase
  end

endmodule