`timescale 1 ns / 10 ps

module stack(input  wire       clk, reset, push, pop, interrupt, 
             input  wire [9:0] pc_addr, 
             output wire [9:0] out, 
             output wire       underflow, overflow);

  reg[9:0] stackmem[0:15]; //memoria de 16 de tamaño con 10 bits de ancho
  reg[4:0] sp;  // Un bit más de control
  wire[3:0] spinc, spdec;
  
  assign spinc = sp + 5'b1;
  assign spdec = sp - 5'b1;

  always @(posedge clk, posedge reset)
  begin
	 if (reset) begin
      sp <= 5'b0;
	end
    else if (push)
    begin
      if (sp[3:0] == 4'b1111)
        sp[4] <= 1'b1;
      else
      begin
        stackmem[spinc] <= pc_addr;
		  sp <= spinc;
      end
    end
    else if (pop)
    begin
      if (sp[3:0] ==  4'b0)
        sp[4] <= 1'b1;
      else
        sp <= spdec;
    end
  end
  assign out = interrupt ? stackmem[sp] : stackmem[sp] + 10'b1;

  assign underflow = !((sp[4] == 1'b1) & (sp[3:0] == 4'b0)) ? 1'b0 : 1'b1;
  assign overflow = !((sp[4] == 1'b1) & (sp[3:0] == 4'b1111)) ? 1'b0 : 1'b1;

endmodule