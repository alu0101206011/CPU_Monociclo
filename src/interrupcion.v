`timescale 1 ns / 10 ps

module gestion_solucitud #(parameter WIDTH = 8) (input wire [WIDTH-1:0] int_e, int_s, s_reti, output wire [WIDTH-1:0] data_s); //ret_i muestra la siguiente sol

  assign data_s = (int_s & ~(s_reti)) | int_e;

endmodule

module gestion_atencion #(parameter WIDTH = 8) (input wire [WIDTH-1:0] int_a, s_calli, s_reti, output wire [WIDTH-1:0] data_a);

  assign data_a = s_calli | (int_a & ~(s_reti));

endmodule

module gestion_interrupcion #(parameter WIDTH = 8) (input wire clk, reset, 
                                                    input wire [WIDTH-1:0] int_e, s_calli, s_reti, 
                                                    output wire [WIDTH-1:0] data_s, int_a,
                                                    output reg [9:0] dir);
  wire [WIDTH-1:0] int_s, data_a, max_bit_a; 

  registro #(WIDTH) Solicitud(clk, reset, data_s, int_s);
  registro #(WIDTH) Atencion(clk, reset, data_a, int_a);

  gestion_solucitud GS(int_e, int_s, s_reti, data_s);
  gestion_atencion GA(int_a, s_calli, s_reti, data_a);

  max_bit maxA(data_a, max_bit_a);

  always @(max_bit_a) 
  begin
    casex (max_bit_a)
      8'b1xxxxxxx: dir = 10'b1000000000;
      8'b01xxxxxx: dir = 10'b1000000001;
      8'b001xxxxx: dir = 10'b1000000010;
      8'b0001xxxx: dir = 10'b1000000011;
      8'b00001xxx: dir = 10'b1000000100;
      8'b000001xx: dir = 10'b1000000101;
      8'b0000001x: dir = 10'b1000000110;
      8'b00000001: dir = 10'b1000000111;
      default: dir = 10'bx; 
    endcase
  end

endmodule

