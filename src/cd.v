`timescale 1 ns / 10 ps

module cd(input wire clk, reset, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, oe,
          input wire [1:0] s_inc,
          input wire [2:0] op_alu, 
          inout wire [15:0] inout_datos, 
          input [7:0] int_e, s_calli, s_reti,
          output wire z, ALUoflow, uflow, oflow, 
          output wire [7:0] opcode, int_a, data_s,
          output wire [15:0] direcciones);
  
  wire[31:0] instruccion;
  wire[9:0] sal_PC, sal_muxINC, sal_sumpc, sal_muxREL, sal_muxPila;

  // Incremento
  registro #(10) PC(clk, reset, sal_muxPila, sal_PC);  // impedir que se escriba
  mux2 #(10) muxREL(10'b1, instruccion[9:0], s_rel_pc, sal_muxREL);
  sum sumINC(sal_muxREL, sal_PC, sal_sumpc);
  mux4 #(10) muxINC(sal_sumpc, instruccion[9:0], dir_i, 10'b0, s_inc, sal_muxINC); //PROBLEMA DE SINCRONIZACIÓN, LA INTERRUPCIÓN PASA DEMASIADO DEPRISA

  // Pila
  wire[9:0] sal_stack;
  wire s_interr;
  pila stack(clk, reset, push, pop, s_interr, sal_PC, sal_stack, uflow, oflow);
  mux2 #(10) muxStack(sal_muxINC, sal_stack, s_pila, sal_muxPila);

  // Memoria
  memprog memoria(clk, sal_PC, instruccion);

  // Datos
  wire zalu, carry; // hacer algo con carry y overflow
  wire[15:0] rd1, rd2, wd, sal_ALU, sal_muxINM;
  regfile banco_registros(clk, we3, instruccion[11:8], instruccion[7:4], instruccion[3:0], wd, rd1, rd2);
  mux2 #(16) muxDATOS(sal_ALU, datos, s_datos, wd);
  mux2 #(16) muxINM(rd1, instruccion[27:12], s_inm, sal_muxINM);
  alu ALU(sal_muxINM, rd2, s_inm, op_alu, sal_ALU, carry, ALUoflow, zalu);

  // Interrupciones
  wire [9:0] dir_i;
  gestion_interrupcion #(8) GI(clk, reset, int_e, s_calli, s_reti, data_s, int_a, dir_i);


  //transeiver
  wire [15:0] datos;
  transceiver tr(clk, reset, oe, rd1, datos, inout_datos);
  
  ffd ffz(clk, reset, zalu, wez, z);

  assign s_interr = int_a > 8'b0 ? 1'b1 : 1'b0;
  assign opcode = instruccion[31:24];

endmodule
