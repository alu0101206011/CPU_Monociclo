`timescale 1 ns / 10 ps

module gestor_e_s(input wire clk, reset,
                  input wire [17:0] addr,
                  inout wire [15:0] datos,
                  input wire [3:0] botones,
                  input wire [9:0] switches,
                  inout wire [9:0] led_r,
                  inout wire [7:0] led_g,
                  output [4:0] control_mem,
                  output [7:0] interrupcion );

  /* reg rwled, rb;

  registro2 #(16) leds_encendidos(clk, reset, rl, leds, datos);
  registro2 #(16) leds_control(clk, reset, wl, datos, leds);

  initial 
  begin
    rwled <= 1'b0;
    ce <= 1'b0;
  end

  always @(*)
    casex (addr) 
      16'b11111111111xxxxx: // la x más significativa si está a 0 es para los botones
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