`timescale 1 ns / 10 ps

module cd(input wire clk, reset, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, oe,
          input wire [1:0] s_inc,
          input wire [2:0] op_alu, 
          inout wire [15:0] inout_datos, 
          input [7:0] int_e, s_calli, s_reti,
          output wire z, c, overflow, 
          output wire [7:0] opcode, min_bit_a, min_bit_s,
          output wire [15:0] direcciones);
  
  wire[31:0] instruccion;
  wire[9:0] sal_PC, sal_muxINC, sal_sumpc, sal_muxREL, sal_muxPila, dir_interrupcion;

  // Incremento
  registro #(10) PC(clk, reset, sal_muxPila, sal_PC);
  mux2 #(10) muxREL(10'b1, instruccion[9:0], s_rel_pc, sal_muxREL);
  sum sumINC(sal_muxREL, sal_PC, sal_sumpc);
  mux4 #(10) muxINC(sal_sumpc, instruccion[9:0], dir_interrupcion, 10'b0, s_inc, sal_muxINC);

  // Pila
  wire[9:0] sal_stack;
  wire s_interr, Stackoflow, Stackuflow;
  pila stack(clk, reset, push, pop, s_interr, sal_PC, sal_stack, Stackuflow, Stackoflow);
  mux2 #(10) muxStack(sal_muxINC, sal_stack, s_pila, sal_muxPila);

  // Memoria
  memprog memoria(clk, sal_PC, instruccion);

  // Datos
  wire [15:0] datos;
  wire zalu, zalu_intr, carry, carry_intr, ALUoflow, sal_z, sal_c, sal_z_intr, sal_c_intr;
  wire[15:0] rd1, rd2, wd, sal_ALU, sal_muxINM;
  regfile banco_registros(clk, we3, instruccion[11:8], instruccion[7:4], instruccion[3:0], wd, rd1, rd2);
  mux2 #(16) muxDATOS(sal_ALU, datos, s_datos, wd);
  mux2 #(16) muxINM(rd1, instruccion[27:12], s_inm, sal_muxINM);
  alu ALU(sal_muxINM, rd2, s_inm, s_interr, op_alu, sal_ALU, carry, carry_intr, ALUoflow, zalu, zalu_intr);

  // Biestables de control
  wire wez_n, wez_i;
  assign wez_n = ~s_interr & wez;
  assign wez_i = s_interr & wez;

  ffd ffz(clk, reset, zalu, wez_n, sal_z);
  ffd ffc(clk, reset, carry, wez_n, sal_c);

  ffd ffz_intr(clk, reset, zalu_intr, wez_i, sal_z_intr);
  ffd ffc_intr(clk, reset, carry_intr, wez_i, sal_c_intr);

  assign z = s_interr ? sal_z_intr : sal_z;
  assign c = s_interr ? sal_c_intr : sal_c;

  // Overflow
  wire oflow;
  assign oflow = Stackuflow | Stackoflow | ALUoflow;
  ffd ffo(clk, reset, oflow, wez, overflow);

  // Interrupciones
  gestion_interrupcion #(8) GI(clk, reset, int_e, s_calli, s_reti, s_interr, min_bit_s, min_bit_a, dir_interrupcion);

  //transeiver
  transceiver tr(clk, reset, oe, rd1, datos, inout_datos);
  
  assign opcode = instruccion[31:24];

endmodule
