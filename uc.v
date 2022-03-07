module uc(input wire [5:0] opcode, input wire z, output reg s_inc, s_inm, s_datos, we3, wez, output reg [2:0] op_alu); //tengo que poner toda la isa bien
  always @(opcode)
  begin
    casex (opcode)
      6'b1000xx:  // Alu (a)
        begin
          op_alu = 3'b000; 
          s_inc = 1'b1;  // para que aumente pc cuando no son saltos  
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b0;
        end
      6'b1001xx:  // Alu (~a)
        begin
          op_alu = 3'b001; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b0;
        end
      6'b1010xx:  // Alu (a + b)
        begin
          op_alu = 3'b010; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b0;
        end
      6'b1011xx:  // Alu (a - b)
        begin 
          op_alu = 3'b011; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b0;
        end
      6'b1100xx:  // Alu (a & b)
        begin
          op_alu = 3'b100;
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b0;
        end
      6'b1101xx:  // Alu (a | b)
        begin
          op_alu = 3'b101; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b0;
        end
      6'b1110xx:  // Alu (-a)
        begin
          op_alu = 3'b110; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b0;
        end
      6'b1111xx:  // Alu (-b)
        begin    
          op_alu = 3'b111; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b0;
        end
      6'b0000xx:  // Alu (a)
        begin
          op_alu = 3'b000; 
          s_inc = 1'b1;  // para que aumente pc cuando no son saltos  
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
        end
      6'b0010xx:  // Alu (a + b)
        begin
          op_alu = 3'b010; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
        end
      6'b0011xx:  // Alu (a - b)
        begin 
          op_alu = 3'b011; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
        end
      6'b0100xx:  // Alu (a & b)
        begin
          op_alu = 3'b100;
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
        end
      6'b0101xx:  // Alu (a | b)
        begin
          op_alu = 3'b101; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
        end
      6'b0110xx:  // Alu (~a)
        begin
          op_alu = 3'b001;
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
        end
      6'b0111xx:  // Alu (-a)
        begin    
          op_alu = 3'b110; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
        end
      6'b000100:  // J
        begin
          op_alu = 3'b000; 
          s_inc = 1'b0; 
          we3 = 1'b0;
          wez = 1'b0;
        end
      6'b000101:  // JZ
        begin
          op_alu = 3'b000; 
          s_inc = z ? 1'b0 : 1'b1;
          we3 = 1'b0;
          wez = 1'b0;
        end
      6'b000110:  // JNZ
        begin
          op_alu = 3'b000; 
          s_inc = z ? 1'b1 : 1'b0;
          we3 = 1'b0;
          wez = 1'b0;
        end
      default:
        begin
          op_alu = 3'b000; 
          s_inc = 1'b0;
          we3 = 1'b0;
          wez = 1'b0;         
          s_inm = 1'b0; 
          s_datos = 1'b0;
        end
    endcase 
    s_datos = 1'b0;
  end
endmodule


/*
Primero los más restrictivos (Opcodes mas pequeños)
OPCODE
J = 000100
JZ = 000101
JNZ = 000110



Oper ALU 8 operaciones  
1000 s = a;
1001 s = ~a;
1010 s = a + b;
1011 s = a - b;
1100 s = a & b;
1101 s = a | b;
1110 s = -a;
1111 s = -b;

0000 s = inm;
0010 s = inm + b;
0011 s = inm - b;
0100 s = inm & b;
0101 s = inm | b;
0110 s = ~inm;
0111 s = -inm;

Direccionamiento inmediato Load / Direccionamiento directo a memoria (Porque los inmediatos y el dir a memoria tienen el mismo tam)  
0000 0000000000000010 0000 0000 0011  R3 = 2  

Direccionamiento directo a registro  
1000 0000000000000000 0001 0000 0011  R3 = R1  

Direccionamiento aritmetico-lógico registros  
1010 0000000000000000 0001 0010 0011  R3 = R1 + R2  

Direccionamiento aritmetico-lógico inmediato  
0010 0000000000000010 0000 0001 0011  R3 = 2 + R1  




*/