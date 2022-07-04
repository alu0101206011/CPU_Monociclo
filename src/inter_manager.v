`timescale 1 ns / 10 ps

module interrupt_manager #(parameter WIDTH = 8) (input wire clk, reset, 
                                                 input wire [WIDTH-1:0] int_e, s_calli, s_reti,
                                                 output wire s_interr,
                                                 output wire [WIDTH-1:0] min_bit_s, min_bit_a, int_a, int_s, data_a, data_s,
                                                 output reg [9:0] addr);
  wire [WIDTH-1:0] sel_a;

  register #(WIDTH) Request(clk, reset, 1'b1, data_s, int_s);
  register #(WIDTH) Attention(clk, reset, 1'b1, data_a, int_a);

  assign data_s = (int_s & ~(s_reti)) | int_e; // request manager

  assign data_a = s_calli | (int_a & ~(s_reti)); // attention manager

  max_priority_bit #(WIDTH) selA(data_a, sel_a);
  max_priority_bit #(WIDTH) maxS(int_s, min_bit_s);
  max_priority_bit #(WIDTH) maxA(int_a, min_bit_a);

  assign s_interr = int_a > 8'b0 ? 1'b1 : 1'b0;

  always @(*)
  begin
    casex (sel_a)
      8'bxxxxxxx1: addr <= 10'b1111111000;
      8'bxxxxxx10: addr <= 10'b1111110000;
      8'bxxxxx100: addr <= 10'b1000010101; 
      8'bxxxx1000: addr <= 10'b1000101001;
      8'bxxx10000: addr <= 10'b1000111101;
      8'bxx100000: addr <= 10'b1001100101;
      8'bx1000000: addr <= 10'b1010001101;
      8'b10000000: addr <= 10'b1010001101;
      default: addr <= 10'bx;
    endcase
  end

endmodule

