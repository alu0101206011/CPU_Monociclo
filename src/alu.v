`timescale 1 ns / 10 ps

module alu #(parameter WIDTH = 16) (input wire [WIDTH-1:0] a, b,
                                    input wire s_inm, interruption,
                                    input wire [2:0] op_alu,
                                    output wire [WIDTH-1:0] y,
                                    output wire carry, carry_intr, overflow, zero, zero_intr);

  reg [WIDTH-1:0] s; // un bit mas de carry
         
  always @(a, b, op_alu)
  begin
    case (op_alu)              
      3'b000: s = a;
      3'b001: s = ~a;
      3'b010: s = a + b;  // el algoritmo de suma y resta es el mismo para binario natural y para C2
      3'b011: s = s_inm ? b - a : a - b;
      3'b100: s = a & b;
      3'b101: s = a | b;
      3'b110: s = -a;  //pueden dar ov
      3'b111: s = s_inm ? -a : -b;  //puede dar ov
    default: s = 16'bx; //desconocido en cualquier otro caso (x � z), por si se modifica el código
    endcase
  end

  // si hay 2 sumas y el resultado tiene 0 diferentes, overflow
  // si hay una resta, complementamos la resta y si el resultado tiene el bit más significativo 

  assign y = s;

  wire ovAdd, ovSub, ovC2;

  assign ovAdd = (op_alu == 3'b010) & ((!a[WIDTH-1] & !b[WIDTH-1] & y[WIDTH-1]) | ((a[WIDTH-1] & b[WIDTH-1] & !y[WIDTH-1])));
  assign ovSub = (op_alu == 3'b011) & ((!s_inm & !a[WIDTH-1] & b[WIDTH-1] & y[WIDTH-1]) | (s_inm & a[WIDTH-1] & !b[WIDTH-1] & y[WIDTH-1]) | (!s_inm & (a[WIDTH-1] & !b[WIDTH-1] & !y[WIDTH-1])) | (s_inm & (!a[WIDTH-1] & b[WIDTH-1] & !y[WIDTH-1])));
  assign ovC2 = ((op_alu == 3'b110 | (op_alu == 3'b111 & s_inm)) & ((a[WIDTH-1] == 1'b1) & (a[WIDTH-1-1:0] == 0))) | ((op_alu == 3'b111) & !s_inm & (b[WIDTH-1] == 1'b1) & (b[WIDTH-2:0] == 0));
  assign overflow = ovAdd | ovSub | ovC2;

  assign carry = interruption ? carry : ((op_alu == 3'b011 & (((!s_inm) & (a < b)) | ((s_inm) & (b < a)))) | (op_alu != 3'b011 & y[WIDTH-1]));
  assign carry_intr = interruption ? ((op_alu == 3'b011 & (((!s_inm) & (a < b)) | ((s_inm) & (b < a)))) | (op_alu != 3'b011 & y[WIDTH-1])) : carry_intr;

  //Calculo del flag de cero
  assign zero = interruption ? zero : ~(|y);   //operador de reducci�n |y hace la or de los bits del vector 'y' y devuelve 1 bit resultado
  assign zero_intr = interruption ? ~(|y) : zero_intr;

endmodule

// a - b = c
//(+) - (-) = (-)
//    (+)
//(-) - (+) = (+)
//    + (-)

// mirar casos especificos 1000

//Borrow llevado al acarreo 
// C = (resta && (a < b)) || )(suma && s[WIDTH-1])