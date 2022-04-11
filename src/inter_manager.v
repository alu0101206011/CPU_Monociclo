`timescale 1 ns / 10 ps

module request_manager #(parameter WIDTH = 8) (input wire [WIDTH-1:0] int_e, int_s, s_reti, output wire [WIDTH-1:0] data_s); //ret_i muestra la siguiente sol

  assign data_s = (int_s & ~(s_reti)) | int_e;

endmodule

module attention_manager #(parameter WIDTH = 8) (input wire [WIDTH-1:0] int_a, s_calli, s_reti, output wire [WIDTH-1:0] data_a);

  assign data_a = s_calli | (int_a & ~(s_reti));

endmodule

module interrupt_manager #(parameter WIDTH = 8) (input wire clk, reset, 
                                                 input wire [WIDTH-1:0] int_e, s_calli, s_reti, 
                                                 output wire s_interr,
                                                 output wire [WIDTH-1:0] min_bit_s, min_bit_a,
                                                 output reg [9:0] addr);
  wire [WIDTH-1:0] int_s, data_s, int_a, data_a, sel_a; 

  register #(WIDTH) Request(clk, reset, 1'b1, data_s, int_s);
  register #(WIDTH) Attention(clk, reset, 1'b1, data_a, int_a);

  request_manager #(WIDTH) RM(int_e, int_s, s_reti, data_s);
  attention_manager #(WIDTH) AM(int_a, s_calli, s_reti, data_a);

  max_priority_bit #(WIDTH) selA(data_a, sel_a);
  max_priority_bit #(WIDTH) maxS(data_s, min_bit_s);
  max_priority_bit #(WIDTH) maxA(int_a, min_bit_a);

  assign s_interr = int_a > 8'b0 ? 1'b1 : 1'b0;

  always @(sel_a)
  begin
    casex (sel_a)
      8'bxxxxxxx1: addr = 10'b1111111100;
      8'bxxxxxx10: addr = 10'b1000000001;
      8'bxxxxx100: addr = 10'b1000010101; 
      8'bxxxx1000: addr = 10'b1000101001;
      8'bxxx10000: addr = 10'b1000111101;
      8'bxx100000: addr = 10'b1001100101;
      8'bx1000000: addr = 10'b1001111001;
      8'b10000000: addr = 10'b1010001101;
      default: addr = 10'bx;
    endcase
  end

endmodule

