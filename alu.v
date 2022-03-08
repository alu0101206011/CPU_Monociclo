module alu #(parameter WIDTH = 15) (input wire [WIDTH:0] a, b,
           input wire [2:0] op_alu,
           output wire [WIDTH:0] y,
           output wire carry, overflow, zero);

  reg [WIDTH + 1:0] s; // un bit mas de carry
         
  always @(a, b, op_alu)
  begin
    case (op_alu)              
      3'b000: s = a;
      3'b001: s = ~a;
      3'b010: s = a + b;
      3'b011: s = a - b;
      3'b100: s = a & b;
      3'b101: s = a | b;
      3'b110: s = -a;
      3'b111: s = -b;
    default: s = 'bx; //desconocido en cualquier otro caso (x � z), por si se modifica el c�digo
    endcase
  end

  parameter min = -(2 ** WIDTH);
  parameter max = (2 ** WIDTH) - 1;

  assign y = s[WIDTH:0];

  assign overflow = (s < min | s > max) ? 1'b1 : 1'b0;
  assign carry = s[WIDTH + 1];


  //Calculo del flag de cero
  assign zero = ~(|y);   //operador de reducci�n |y hace la or de los bits del vector 'y' y devuelve 1 bit resultado

endmodule

// Estaría bien poner más señales que solo cuando hay un 0. Estaría interesante poner cuando hay overflow, cuando hay acarreo.