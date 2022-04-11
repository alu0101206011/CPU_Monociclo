`timescale 1 ns / 10 ps

module cpu(input wire clk, reset, input wire [7:0] int_e, output wire oe, output wire [15:0] addresses, inout wire [15:0] data);
    wire [7:0] opcode, s_calli, s_reti, min_bit_a, min_bit_s;
    wire [2:0] op_alu;
    wire [1:0] s_inc;
    wire s_jrel_pc, s_inm, s_data, we3, wez, ALUoflow, s_stack, push, pop, overflow, z, c;

    dp data_path(clk, reset, s_jrel_pc, s_inm, s_stack, s_data, we3, wez, push, pop, oe, s_inc, op_alu, data, int_e, s_calli, s_reti, z, c, overflow, opcode, min_bit_a, min_bit_s, addresses);
    cu control_unit(opcode, z, c, overflow, min_bit_s, min_bit_a, s_jrel_pc, s_inm, s_stack, s_data, we3, wez, push, pop, oe, s_inc, op_alu, s_calli, s_reti);
endmodule