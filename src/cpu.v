`timescale 1 ns / 10 ps

module cpu(input wire clk, reset, input wire [15:0] datos, input wire [7:0] interrupcion, output wire [15:0] direcciones); // datos y direcciones salen de la cpu
    wire [7:0] opcode, interrupcion_vec;
    wire [2:0] op_alu;
    wire s_inc, s_rel_pc, s_inm, s_datos, we3, wez, ALUoflow, s_pila, push, pop, uflow, oflow, z;

    cd camino_datos(clk, reset, s_inc, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, op_alu, datos, interrupcion_vec, z, ALUoflow, uflow, oflow, opcode, direcciones);
    uc unidad_control(opcode, z, uflow, oflow, interrupcion, s_inc, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, op_alu, interrupcion_vec);
endmodule