module cpu(input wire clk, reset); // datos y direcciones salen de la cpu
    wire [5:0] opcode;
    wire [2:0] op_alu;
    wire s_inc, s_inm, s_datos, we3, wez, z;
    wire [15:0] datos, direcciones;

    cd camino_datos(clk, reset, s_inc, s_inm, s_datos, we3, wez, op_alu, datos, z, opcode, direcciones);
    uc unidad_control(opcode, z, s_inc, s_inm, s_datos, we3, wez, op_alu);

endmodule