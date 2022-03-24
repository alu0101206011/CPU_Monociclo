`timescale 1 ns / 10 ps

module cpu(input wire clk, reset, inout wire [15:0] inout_datos, input wire [7:0] int_e, output wire [15:0] direcciones); // datos y direcciones salen de la cpu
    wire [7:0] opcode, s_calli, s_reti, int_a, data_s;
    wire [2:0] op_alu;
    wire [1:0] s_inc;
    wire s_rel_pc, s_inm, s_datos, we3, wez, ALUoflow, s_pila, push, pop, uflow, oflow, z;

    cd camino_datos(clk, reset, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, oe, s_inc, op_alu, inout_datos, int_e, s_calli, s_reti, z, ALUoflow, uflow, oflow, opcode, int_a, data_s, direcciones);
    uc unidad_control(opcode, z, uflow, oflow, data_s, int_a, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, oe, s_inc, op_alu, s_calli, s_reti);
endmodule