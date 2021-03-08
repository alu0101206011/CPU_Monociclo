//module registro #(parameter WIDTH = 8) (input wire clk, reset, input wire [WIDTH-1:0] d, output reg [WIDTH-1:0] q);
//module mux2 #(parameter WIDTH = 8)(input  wire [WIDTH-1:0] d0, d1, input  wire s, output wire [WIDTH-1:0] y);
//module sum(input  wire [9:0] a, b,output wire [9:0] y);
//module memprog(input  wire clk,input  wire [9:0]  a,output wire [15:0] rd);
/*module regfile(input  wire        clk, 
               input  wire        we3,           //se�al de habilitaci�n de escritura
               input  wire [3:0]  ra1, ra2, wa3, //direcciones de regs leidos y reg a escribir
               input  wire [7:0]  wd3, 			 //dato a escribir
               output wire [7:0]  rd1, rd2);     //datos leidos  
  module alu(input wire [7:0] a, b,
           input wire [2:0] op_alu,
           output wire [7:0] y,
           output wire zero);   */
// module ffd(input wire clk, reset, d, carga, output reg q);

module cd(input wire clk, reset, s_inc, s_inm, we3, wez, input wire [2:0] op_alu, output wire z, output wire [5:0] opcode);
//Camino de datos de instrucciones de un solo ciclo
wire zalu;
wire[9:0] sal_PC, sal_muxINC, sal_sum;
wire[7:0] rd1, rd2, wd3, sal_ALU; 
wire[15:0] instruccion;

registro #(10) PC(clk, reset, sal_muxINC, sal_PC);
sum sumINC(10'b0000000001, sal_PC, sal_sum);
mux2 #(10) muxINC (instruccion[9:0], sal_sum, s_inc, sal_muxINC); //Cuidado con el orden de a y b entradas
memprog memoria(clk, sal_PC, instruccion);
regfile banco_registros(clk, we3, instruccion[11:8], instruccion[7:4], instruccion[3:0], wd3, rd1,rd2);
mux2 muxINM(sal_ALU, instruccion[11:4], s_inm, wd3);
alu ALU(rd1, rd2, op_alu, sal_ALU, zalu);
ffd ffz(clk, reset, zalu, wez, z);

assign opcode = instruccion[15:10];

endmodule
