`timescale 1 ns / 10 ps

module io_manager(input wire clk, reset, oe_cpu, 
                   input wire [15:0] addr,
                   input wire [3:0] buttons,
                   input wire [9:0] switches,
                   output wire [9:0] led_r,
                   output wire [7:0] led_g,
                   output wire [4:0] control_mem, // we ce oe_mem lb ub
                   inout wire [15:0] data);

  wire wr, wg;
  wire [15:0] data_cpu;

  reg oe_io;
  reg [6:0] control;
  reg [15:0] data_io;
  //wire [9:0] led_r;
  //wire [7:0] led_g;

  register #(10) leds_red(clk, reset, wr, data_cpu[9:0], led_r);
  register #(8) leds_green(clk, reset, wg, data_cpu[7:0], led_g);

  assign {wr, wg, control_mem} = control;

  parameter LED_RED = 7'b10x1xxx;
  parameter LED_GREEN = 7'b01x1xxx;
  parameter NOP = 7'b00x1xxx;
  parameter MEMORY_STORE = 7'b0000x00;  // we ce oe_mem lb ub
  parameter MEMORY_LOAD = 7'b0010000;

  always @(*)
  begin
    if (reset)
    begin
      data_io <= 16'b0;
      oe_io <= 1'b0;
		control <= NOP;
    end
    else
    begin
      case (addr) // usando parte de la memoria para controlar leds
        16'b1111111111111100:
        begin
          control <= NOP;
          data_io <= {6'b0, switches[8:0]};
          oe_io <= 1'b1;
        end		
        16'b1111111111111101:
        begin
          control <= NOP;
          data_io <= {12'b0, ~buttons};
          oe_io <= 1'b1;
        end
        16'b1111111111111110:
        begin
          control <= oe_cpu ? LED_RED : NOP;
          data_io <= {5'b0, led_r};
          oe_io <= ~oe_cpu;
        end
        16'b1111111111111111:
        begin
          control <= oe_cpu ? LED_GREEN : NOP;
          data_io <= {7'b0, led_g};
          oe_io <= ~oe_cpu;
        end
        default: 
        begin
          control <= oe_cpu ? MEMORY_STORE : MEMORY_LOAD;
          data_io <= 16'b0;
          oe_io <= 1'b0;
        end
      endcase
    end
  end

  transceiver transceiver2(oe_io, data_io, data_cpu, data);

endmodule