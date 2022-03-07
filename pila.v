module pila(input wire clk, reset, push, pop, input wire[9:0] pc_addr, output reg [9:0] sp, output wire underflow, overflow);

  reg[15:0] mempila[0:9]; //memoria de 16 de tamaño con 10 bits de ancho
  reg[16:0] position;  // Puede tener un bit más de control

  always @(posedge clk, reset)
  begin
    if (push)
    begin
      if (position[15:0] ==  15'b111111111111111)
        position[16] = 1'b1;
      else
        position = position + 16'b0000000000000001;
      mempila[position] <= pc_addr;
    end
    else if (pop)
    begin
      mempila[position] = 10'b0000000000;
      if (position[15:0] ==  15'b000000000000000)
        position[16] = 1'b1;
      else
        position = position - 16'b0000000000000001;
    end
    else if (reset)
    begin
      position = 16'b0000000000000000;
      mempila[position] = 10'b0000000000;
    end
    sp = mempila[position];
  end

  assign underflow = reset | !((position[16] == 1) & (position[15:0] == 15'b000000000000000)) ? 1'b0 : 1'b1;
  assign overflow = reset | !((position[16] == 1) & (position[15:0] == 15'b111111111111111)) ? 1'b0 : 1'b1;

endmodule