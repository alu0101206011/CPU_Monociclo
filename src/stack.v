`timescale 1 ns / 10 ps

module stack(input  wire       clk, reset, push, pop, interrupt, 
             input  wire [9:0] pc_addr, 
             output wire [9:0] out, 
             output wire       underflow, overflow);

  reg[9:0] stackmem[0:15]; //memoria de 16 de tamaño con 10 bits de ancho
  reg[16:0] sp;  // Un bit más de control

  always @(posedge clk, reset)
  begin
    if (push)
    begin
      if (sp[15:0] == 16'b1111111111111111)
        sp[16] <= 1'b1;
      else
      begin
        sp <= sp + 16'b1;
        stackmem[sp + 16'b1] <= pc_addr;
      end
    end
    else if (pop)
    begin
      if (sp[15:0] ==  16'b0)
        sp[16] <= 1'b1;
      else
        sp <= sp - 16'b1;
    end
    else if (reset)
      sp <= 16'b0;
  end
  assign out = interrupt ? stackmem[sp] : stackmem[sp] + 10'b1;

  assign underflow = !((sp[16] == 1'b1) & (sp[15:0] == 16'b0)) ? 1'b0 : 1'b1;
  assign overflow = !((sp[16] == 1'b1) & (sp[15:0] == 16'b1111111111111111)) ? 1'b0 : 1'b1;

endmodule