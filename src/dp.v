`timescale 1 ns / 10 ps

module dp(input wire clk, reset, s_rel, s_inm, s_stack, s_data, we3, wez, push, pop, oe,
          input wire [1:0] s_inc,
          input wire [2:0] op_alu, 
          inout wire [15:0] data_inout, 
          input [7:0] int_e, s_calli, s_reti,
          output wire z, c, overflow,
          output wire [7:0] opcode, min_bit_a, min_bit_s,
          output wire [15:0] addresses);
  
  wire[31:0] instructions;
  wire[9:0] out_PC, out_incMux, out_pcAdder, out_relMux, out_stackMux, interr_addr;

  // Incremento
  register #(10) PC(clk, reset, 1'b1, out_stackMux, out_PC);
  mux2 #(10) relMux(10'b1, instructions[9:0], s_rel, out_relMux);
  adder incAdder(out_relMux, out_PC, out_pcAdder);
  mux4 #(10) incMux(out_pcAdder, instructions[9:0], interr_addr, 10'b0, s_inc, out_incMux);

  // Pila
  wire[9:0] out_stack;
  wire s_interr, stackOflow, stackUflow;
  stack Stack(clk, reset, push, pop, s_interr, out_PC, out_stack, stackUflow, stackOflow);
  mux2 #(10) stackMux(out_incMux, out_stack, s_stack, out_stackMux);

  // Memoria
  memprog memory_program(clk, out_PC, instructions);

  // Datos
  wire zalu, zalu_intr, carry, carry_intr, aluOflow, out_ffz, out_ffc, out_ffz_intr, out_ffc_intr;
  wire[15:0] data, rd1, rd2, wd, out_ALU, out_inmMux;
  regfile register_file(clk, we3, instructions[27:24], instructions[23:20], instructions[19:16], wd, rd1, rd2);
  mux2 #(16) dataMux(out_ALU, data, s_data, wd);
  mux2 #(16) inmMux(rd1, instructions[15:0], s_inm, out_inmMux);
  alu ALU(out_inmMux, rd2, s_inm, s_interr, op_alu, out_ALU, carry, carry_intr, aluOflow, zalu, zalu_intr);

  // Biestables de control
  wire wez_n, wez_i;
  assign wez_n = ~s_interr & wez;
  assign wez_i = s_interr & wez;

  ffd ffz(clk, reset, zalu, wez_n, out_ffz);
  ffd ffc(clk, reset, carry, wez_n, out_ffc);

  ffd ffz_intr(clk, reset, zalu_intr, wez_i, out_ffz_intr);
  ffd ffc_intr(clk, reset, carry_intr, wez_i, out_ffc_intr);

  assign z = s_interr ? out_ffz_intr : out_ffz;
  assign c = s_interr ? out_ffc_intr : out_ffc;

  // Overflow
  wire oflow;
  assign oflow = stackUflow | stackOflow | aluOflow;
  ffd ffo(clk, reset, oflow, wez, overflow);

  // Interrupciones
  interrupt_manager #(8) IM(clk, reset, int_e, s_calli, s_reti, s_interr, min_bit_s, min_bit_a, interr_addr);

  //transeiver
  transceiver tr(oe, rd1, data, data_inout);
  assign addresses = out_ALU;
  assign opcode = instructions[31:24];

endmodule
