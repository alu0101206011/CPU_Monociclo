`timescale 1 ns / 10 ps

module i_o_manager(input wire clk, reset,
                   input wire [17:0] addr,
                   inout wire [15:0] data,
                   input wire [3:0] buttons,
                   input wire [9:0] switches,
                   inout wire [9:0] led_r,
                   inout wire [7:0] led_g,
                   output [4:0] control_mem,
                   output [7:0] interruptions );

  /* reg rwled, rb;

  register #(16) leds_encendidos(clk, reset, rl, leds, data);
  register #(16) leds_control(clk, reset, wl, data, leds);

  initial 
  begin
    rwled <= 1'b0;
    ce <= 1'b0;
  end

  always @(*)
    casex (addr) 
      16'b11111111111xxxxx: // la x más significativa si está a 0 es para los buttons
      begin
        rwled <= 1'b1;
        ce <= 1'b0;
      end
      default:
      begin
        rwled <= 1'b0;
        ce <= 1'b1;        
      end
    endcase */

endmodule