module cpu(input wire clk, reset); // datos y direcciones salen de la cpu
    wire [7:0] opcode;
    wire [2:0] op_alu;
    wire s_inc, s_rel_pc, s_inm, s_datos, we3, wez, ALUoflow, s_pila, push, pop, uflow, oflow;
    wire [15:0] datos, direcciones;

    cd camino_datos(clk, reset, s_inc, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, interrupt, op_alu, datos, z, ALUoflow, uflow, oflow, opcode, direcciones);
    uc unidad_control(opcode, z, uflow, oflow, s_inc, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, interrupt, op_alu);
endmodule