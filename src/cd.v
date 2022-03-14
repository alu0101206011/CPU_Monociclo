module cd(input wire clk, reset, s_inc, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, interrupt, input wire [2:0] op_alu, input wire [15:0] datos, output wire z, ALUoflow, uflow, oflow, output wire [7:0] opcode, output wire [15:0] direcciones);
  
  wire[31:0] instruccion;
  wire[9:0] sal_PC, sal_muxINC, sal_sumpc, sal_muxREL;

  // Incremento
  registro #(10) PC(clk, reset, sal_muxPila, sal_PC);
  mux2 #(10) muxREL(10'b1, instruccion[9:0], s_rel_pc, sal_muxREL);
  sum sumINC(sal_muxREL, sal_PC, sal_sumpc);
  mux2 #(10) muxINC(instruccion[9:0], sal_sumpc, s_inc, sal_muxINC); //Cuidado con el orden de a y b entradas

  // Pila
  wire[9:0] sal_stack, sal_muxPila;
  pila stack(clk, reset, push, pop, interrupt, sal_PC, sal_stack, uflow, oflow);
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


  ffd ffz(clk, reset, zalu, wez, z);

  assign opcode = instruccion[31:24];

endmodule
