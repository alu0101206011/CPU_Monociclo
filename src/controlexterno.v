`timescale 1 ns / 10 ps


module e_s_input(input wire [15:0] addr, botones, inout wire [15:0] datos, input wire [15:0] leds, output wire ce);
  
  wire we;

  registro2 #(16) leds_encendidos(clk, reset, we, leds, datos);

  always @(*)
    casex (addr) 
      111111111111xxxx:
      begin
        we = 1'b1;
        ce = 1'b0;
      end
      default:
      begin
        we = 1'b0;
        ce = 1'b1;        
      end
    endcase
  
endmodule


module e_s_output(input wire clk, reset, input wire [15:0] addr, botones, inout wire [15:0] datos, output wire ce, output wire [15:0] leds);

  wire we;

  registro2 #(16) leds_control(clk, reset, we, datos, leds);
  
  always @(*)
    casex (addr) 
      111111111111xxxx:
      begin
        we = 1'b1;
        ce = 1'b0;
      end
      default:
      begin
        we = 1'b0;
        ce = 1'b1;        
      end
    endcase
  
endmodule


module e_s(input wire clk, reset, input wire [15:0] addr, botones, inout wire [15:0] datos, output wire ce, inout wire [15:0] leds);

  wire we;

  e_s_input e_sIn(clk, reset, addr, botones, datos, leds, ce);
  e_s_output e_sOut(clk, reset, addr, botones, datos, ce, leds);

  registro2 #(16) button_control(clk, reset, we, datos, leds);

  always @(*)
    casex (addr) 
      111111111110xxxx:
      begin
        we = 1'b1;
        ce = 1'b0;
      end
      default:
      begin
        we = 1'b0;
        ce = 1'b1;        
      end
    endcase  

endmodule