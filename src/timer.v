`timescale 1 ns / 10 ps
module timer (input wire clk, reset, input wire [7:0] limite, output reg[7:0] pulso);

  reg [7:0] contador;

  always @(posedge clk)
  begin
    if (reset)
    begin
      contador = 8'b1;
      pulso <= 8'b0;
    end
    else if (contador < limite)
    begin
      contador = contador + 8'b1;
      pulso <= 8'b0;
    end
    else
    begin
      if (limite != 8'b0)
      begin
        pulso <= 8'b10000000;
      end
      else
        pulso <= 8'b0;
      contador = 8'b1;
    end
  end

endmodule