module uc(input wire [7:0] opcode, input wire z, output reg s_inc, s_rel_pc, s_inm, s_datos, we3, wez, output reg [2:0] op_alu); //tengo que poner toda la isa bien
  initial
  begin
    op_alu = 3'b000; 
    s_inc = 1'b0;
    we3 = 1'b0;
    wez = 1'b0;         
    s_inm = 1'b0; 
    s_datos = 1'b0;
    s_rel_pc = 1'b0;
  end
  
  always @(opcode)
  begin
    casex (opcode)
      8'b1xxxxxxx: // aritmetico-lógico registros
      begin
        op_alu = opcode[6:4];
        s_inm = 1'b0;
        s_inc = 1'b1;
        we3 = 1'b1;
        wez = 1'b1;
        s_rel_pc = 1'b0;
      end
      8'b0000xxxx:  // Alu (a)
      begin
        op_alu = 3'b000; 
        s_inc = 1'b1;  // para que aumente pc cuando no son saltos  
        we3 = 1'b1;
        wez = 1'b1;
        s_inm = 1'b1;
        s_rel_pc = 1'b0;
      end
      8'b0010xxxx:  // Alu (a + b)
        begin
          op_alu = 3'b010; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
          s_rel_pc = 1'b0;
        end
      8'b0011xxxx:  // Alu (a - b)
        begin 
          op_alu = 3'b011; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
          s_rel_pc = 1'b0;
        end
      8'b0100xxxx:  // Alu (a & b)
        begin
          op_alu = 3'b100;
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
          s_rel_pc = 1'b0;
        end
      8'b0101xxxx:  // Alu (a | b)
        begin
          op_alu = 3'b101; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
          s_rel_pc = 1'b0;
        end
      8'b0110xxxx:  // Alu (~a)
        begin
          op_alu = 3'b001;
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
          s_rel_pc = 1'b0;
        end
      8'b0111xxxx:  // Alu (-a)
        begin    
          op_alu = 3'b110; 
          s_inc = 1'b1;
          we3 = 1'b1;
          wez = 1'b1;
          s_inm = 1'b1;
          s_rel_pc = 1'b0;
      end
      8'b00010000: // Direccionamiento inmediato   opcode e inmediato (16 bits)
      begin
        
      end
      8'b00010001: // Direccionamiento directo     opcode y direccion de memoria (por el cable datos está el operando)  (16 bits)
      begin
        
      end
      8'b00010010: // Direccionamiento indirecto   opcode y dirección de memoria que luego tiene otra en memoria  (20 bits)
      begin
        
      end
      8'b00010011: // Direccionamiento directo por registro   opcode y registro (4 bits)
      begin
        
      end
      8'b00010100: // Direccionamiento relativo   opcode y registro 24 bits 
      begin
        
      end
      8'b00010101: // salto absoluto o relativo a base
      begin
        op_alu = 3'b000;
        s_inm = 1'b0;
        s_rel_pc = 1'b0;
        s_inc = 1'b0;
        we3 = 1'b0;
        wez = 1'b0;
      end
      8'b00010110: // salto relativo a pc
      begin
        op_alu = 3'b000;
        s_inm = 1'b0;
        s_rel_pc = 1'b1;
        s_inc = 1'b1;
        we3 = 1'b0;
        wez = 1'b0;
      end
      8'b00010111: // salto jz
      begin
        op_alu = 3'b000;
        s_inm = 1'b0;
        s_rel_pc = 1'b0;
        s_inc = z ? 1'b0 : 1'b1;
        we3 = 1'b0;
        wez = 1'b0;     
      end
      8'b00011000: // salto jnz
      begin 
        op_alu = 3'b000;
        s_inm = 1'b0;
        s_rel_pc = 1'b0;
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