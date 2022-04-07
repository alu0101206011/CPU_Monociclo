`timescale 1 ns / 10 ps

module gestion_solucitud #(parameter WIDTH = 8) (input wire [WIDTH-1:0] int_e, int_s, s_reti, output wire [WIDTH-1:0] data_s); //ret_i muestra la siguiente sol

  assign data_s = (int_s & ~(s_reti)) | int_e;

endmodule

module gestion_atencion #(parameter WIDTH = 8) (input wire [WIDTH-1:0] int_a, s_calli, s_reti, output wire [WIDTH-1:0] data_a);

  assign data_a = s_calli | (int_a & ~(s_reti));

endmodule

module gestion_interrupcion #(parameter WIDTH = 8) (input wire clk, reset, 
                                                    input wire [WIDTH-1:0] int_e, s_calli, s_reti, 
                                                    output wire s_interr,
                                                    output wire [WIDTH-1:0] min_bit_s, min_bit_a,
                                                    output reg [9:0] dir);
  wire [WIDTH-1:0] int_s, data_s, int_a, data_a, sel_a; 

  registro #(WIDTH) Solicitud(clk, reset, data_s, int_s);
  registro #(WIDTH) Atencion(clk, reset, data_a, int_a);

  gestion_solucitud GS(int_e, int_s, s_reti, data_s);
  gestion_atencion GA(int_a, s_calli, s_reti, data_a);

  max_priority_bit selA(data_a, sel_a);
  max_priority_bit maxS(data_s, min_bit_s);
  max_priority_bit maxA(int_a, min_bit_a);

  assign s_interr = int_a > 8'b0 ? 1'b1 : 1'b0;

  always @(sel_a)
  begin
    casex (sel_a)
      8'bxxxxxxx1: dir = 10'b1111111100;
      8'bxxxxxx10: dir = 10'b1000000001;
      8'bxxxxx100: dir = 10'b1000000110; 
      8'bxxxx1000: dir = 10'b1000001011;
      8'bxxx10000: dir = 10'b1000010000;
      8'bxx100000: dir = 10'b1000010101;
      8'bx1000000: dir = 10'b1000011010;
      8'b10000000: dir = 10'b1000011111;
      default: dir = 10'bx; 
    endcase
  end

endmodule

