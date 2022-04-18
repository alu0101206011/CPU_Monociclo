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
  wire [15:0] data_cpu;
  wire [9:0] filter_r;
  wire [7:0] filter_g, intr;

  reg le;
  reg [6:0] control;
  reg [15:0] data_io;

  assign filter_r = led_r ^ data_cpu[9:0];
  assign filter_g = led_g ^ data_cpu[7:0];

  register #(10) leds_red(clk, reset, wr, filter_r, led_r);
  register #(8) leds_green(clk, reset, wg, filter_g, led_g);

  assign {wr, wg, control_mem} = control;

  parameter LED_RED = 7'b10x1xxx;
  parameter LED_GREEN = 7'b01x1xxx;
  parameter NOP = 7'b00x1xxx;
  parameter MEMORY_STORE = 7'b0000x00;
  parameter MEMORY_LOAD = 7'b0010000;

  always @(*)
  begin
    if (reset)
    begin
      interruptions <= 8'b0;
      data_io <= 16'b0;
    end

    le = 1'b0;

    case (addr[15:0]) // para escribir en leds
		16'b1111111111111101:
		begin
		  control <= NOP;
		  data_io <= buttons;
      le = 1'b1;
		end
      16'b1111111111111110: 
      begin
        control <= oe ? LED_RED : NOP;
        data_io <= led_r;
        le = ~oe; 
      end
      16'b1111111111111111: 
      begin
        control <= oe ? LED_GREEN : NOP;
        data_io <= led_g; 
        le = ~oe; 
      end
      default: control <= oe ? MEMORY_STORE : MEMORY_LOAD;
    endcase
  end

  transceiver transceiver2(le, data_io, data_cpu, data); // parada a leer leds

  assign intr = interruptions; // Para quitar warnings en el quartus

endmodule