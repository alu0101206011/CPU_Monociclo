`timescale 1 ns / 10 ps

module e_s(input wire clk, reset, input wire [15:0] addr, botones, inout wire [15:0] datos, output reg ce, inout wire [15:0] leds);

  reg rwled, rb;

  registro2 #(16) leds_encendidos(clk, reset, rl, leds, datos);
  registro2 #(16) leds_control(clk, reset, wl, datos, leds);
  registro2 #(16) button_control(clk, reset, rb, datos, leds);

  initial 
  begin
    rwled <= 1'b0;
    rb <= 1'b0;
    ce <= 1'b0;
  end

  always @(*)
    casex (addr) 
      16'b11111111111xxxxx: // la x más significativa si está a 0 es para los botones
      begin
        if (16'b111111111110xxxx)
          rb <= 1'b1;
        else 
          rwled <= 1'b1;
        ce <= 1'b0;
      end
      default:
      begin
        rb <= 1'b0;
        rwled <= 1'b0;
        ce <= 1'b1;        
      end
    endcase

endmodule