//module registro #(parameter WIDTH = 8) (input wire clk, reset, input wire [WIDTH-1:0] d, output reg [WIDTH-1:0] q);
//module mux2 #(parameter WIDTH = 8)(input  wire [WIDTH-1:0] d0, d1, input  wire s, output wire [WIDTH-1:0] y);
//module sum(input  wire [9:0] a, b,output wire [9:0] y);
//module memprog(input  wire clk,input  wire [9:0]  a,output wire [15:0] wd);
/*module regfile(input  wire        clk, 
               input  wire        we3,           //se�al de habilitaci�n de escritura
               input  wire [3:0]  ra1, ra2, wa3, //direcciones de regs leidos y reg a escribir
               input  wire [7:0]  wd, 			 //dato a escribir
               output wire [7:0]  rd1, rd2);     //datos leidos  
  module alu(input wire [7:0] a, b,
           input wire [2:0] op_alu,
           output wire [7:0] y,
           output wire zero);   */
// module ffd(input wire clk, reset, d, carga, output reg q);

module cd(input wire clk, reset, s_inc, s_inm, s_datos, we3, wez, input wire [2:0] op_alu, input wire [15:0] datos, output wire z, output wire [5:0] opcode, output wire [15:0] direcciones);
//Camino de datos de instrucciones de un solo ciclo
  wire zalu;
  wire[9:0] sal_PC, sal_muxINC, sal_sum;
  wire[15:0] rd1, rd2, wd, sal_ALU, sal_muxINM;
  wire[31:0] instruccion;

  registro #(10) PC(clk, reset, sal_muxINC, sal_PC);
  sum sumINC(10'b0000000001, sal_PC, sal_sum);
  mux2 #(10) muxINC(instruccion[9:0], sal_sum, s_inc, sal_muxINC); //Cuidado con el orden de a y b entradas
  memprog memoria(clk, sal_PC, instruccion);
  regfile banco_registros(clk, we3, instruccion[11:8], instruccion[7:4], instruccion[3:0], wd, rd1, rd2);
  mux2 #(16) muxDATOS(sal_ALU, datos, s_datos, wd);
  mux2 #(16) muxINM(rd1, instruccion[27:12], s_inm, sal_muxINM);
  alu ALU(sal_muxINM, rd2, op_alu, sal_ALU, zalu);
  ffd ffz(clk, reset, zalu, wez, z);

  assign opcode = instruccion[31:26];

endmodule
/*
Primero los más restrictivos (Opcodes mas pequeños)
OPCODE
J = 000100
JZ = 000101
JNZ = 000110

Oper ALU 8 operaciones  
1000 s = a;
1001 s = ~a;
1010 s = a + b;
1011 s = a - b;
1100 s = a & b;
1101 s = a | b;
1110 s = -a;
1111 s = -b;

0000 s = inm;
0010 s = inm + b;
0011 s = inm - b;
0100 s = inm & b;
0101 s = inm | b;
0110 s = ~inm;
0111 s = -inm;

Direccionamiento inmediato Load / Direccionamiento directo a memoria (Porque los inmediatos y el dir a memoria tienen el mismo tam)  
0000 0000000000000010 0000 0000 0011  R3 = 2  

Direccionamiento directo a registro  
1000 0000000000000000 0001 0000 0011  R3 = R1  

Direccionamiento aritmetico-lógico registros  
1010 0000000000000000 0001 0010 0011  R3 = R1 + R2  

Direccionamiento aritmetico-lógico inmediato  
0010 0000000000000010 0000 0001 0011  R3 = 2 + R1  




*/