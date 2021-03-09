module uc(input wire [5:0] opcode, input wire z, output reg s_inc, s_inm, we3, wez, output reg [2:0] op_alu);
  always @(opcode)
  begin
    casex (opcode)
      6'b1000xx:  // Alu (a)
        begin
          op_alu = 3'b000; 
          s_inc = 1'b1;  // para que aumente pc cuando no son saltos
          s_inm = 1'b0;  
          we3 = 1'b0;
          wez = 1'b1;
        end
      6'b1001xx:  // Alu (~a)
        begin
          op_alu = 3'b001; 
          s_inc = 1'b1;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b1;
        end
      6'b1010xx:  // Alu (a + b)
        begin
          op_alu = 3'b010; 
          s_inc = 1'b1;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b1;
        end
      6'b1011xx:  // Alu (a - b)
        begin 
          op_alu = 3'b011; 
          s_inc = 1'b1;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b1;
        end
      6'b1100xx:  // Alu (a & b)
        begin
          op_alu = 3'b100;
          s_inc = 1'b1;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b1;
        end
      6'b1101xx:  // Alu (a | b)
        begin
          op_alu = 3'b101; 
          s_inc = 1'b1;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b1;
        end
      6'b1110xx:  // Alu (-a)
        begin
          op_alu = 3'b110; 
          s_inc = 1'b1;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b1;
        end
      6'b1111xx:  // Alu (-b)
        begin    
          op_alu = 3'b111; 
          s_inc = 1'b1;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b1;
        end
      6'b0000xx:  // Carga inm
        begin
          op_alu = 3'b000; 
          s_inc = 1'b1;
          s_inm = 1'b1;
          we3 = 1'b1;
          wez = 1'b0;
        end
      6'b000100:  // J
        begin
          op_alu = 3'b000; 
          s_inc = 1'b0; 
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b0;
        end
      6'b000101:  // JZ
        begin
          op_alu = 3'b000; 
          s_inc = z ? 1'b0 : 1'b1;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b0;
        end
      6'b000110:  // JNZ
        begin
          op_alu = 3'b000; 
          s_inc = z ? 1'b1 : 1'b0;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b0;
        end
      default :
        begin
          op_alu = 3'b000; 
          s_inc = 1'b0;
          s_inm = 1'b0;
          we3 = 1'b0;
          wez = 1'b0;          
        end
    endcase 
  end

endmodule


/*
Primero los más restrictivos (Opcodes mas pequeños)
OPCODE
J = 000100
JZ = 000101
JNZ = 000110

LI = 0000

Oper ALU 8 operaciones
1000 s = a;
1001 s = ~a;
1010 s = a + b;
1011 s = a - b;
1100 s = a & b;
1101 s = a | b;
1110 s = -a;
1111 s = -b;

*/