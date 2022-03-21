`timescale 1 ns / 10 ps

module uc(input wire [7:0] opcode, input wire z, uflow, oflow, input wire [7:0] interrupcion, output reg s_inc, s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, output reg [2:0] op_alu, output reg [7:0] interrupcion_vec);
  
  initial
  begin
    op_alu <= 3'b000; 
    s_inc <= 1'b0;
    we3 <= 1'b0;
    wez <= 1'b0;         
    s_inm <= 1'b0; 
    s_datos <= 1'b0;
    s_rel_pc <= 1'b0;
    s_pila <= 1'b0;
    push <= 1'b0;
    pop <= 1'b0;
  end
  
  always @(opcode, interrupcion)
  begin
    casex (opcode)
      8'b1xxxxxxx: // aritmetico-lógico registros
      begin
        op_alu <= opcode[6:4];
        s_inm <= 1'b0;
        s_inc <= 1'b1;
        we3 <= 1'b1;
        wez <= 1'b1;
        s_rel_pc <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b0;
        pop <= 1'b0;
      end
      8'b0000xxxx:  // Alu (a)
      begin
        op_alu <= 3'b000;
        s_inc <= 1'b1;
        we3 <= 1'b1;
        wez <= 1'b1;
        s_inm <= 1'b1;
        s_rel_pc <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b0;
        pop <= 1'b0;        
      end
      8'b0010xxxx:  // Alu (a + b)
        begin
          op_alu <= 3'b010;
          s_inc <= 1'b1;
          we3 <= 1'b1;
          wez <= 1'b1;
          s_inm <= 1'b1;
          s_rel_pc <= 1'b0;
          s_pila <= 1'b0;
          push <= 1'b0;
          pop <= 1'b0;
        end
      8'b0011xxxx:  // Alu (a - b)
        begin 
          op_alu <= 3'b011; 
          s_inc <= 1'b1;
          we3 <= 1'b1;
          wez <= 1'b1;
          s_inm <= 1'b1;
          s_rel_pc <= 1'b0;
          s_pila <= 1'b0;
          push <= 1'b0;
          pop <= 1'b0;
        end
      8'b0100xxxx:  // Alu (a & b)
        begin
          op_alu <= 3'b100;
          s_inc <= 1'b1;
          we3 <= 1'b1;
          wez <= 1'b1;
          s_inm <= 1'b1;
          s_rel_pc <= 1'b0;
          s_pila <= 1'b0;
          push <= 1'b0;
          pop <= 1'b0;
        end
      8'b0101xxxx:  // Alu (a | b)
        begin
          op_alu <= 3'b101; 
          s_inc <= 1'b1;
          we3 <= 1'b1;
          wez <= 1'b1;
          s_inm <= 1'b1;
          s_rel_pc <= 1'b0;
          s_pila <= 1'b0;
          push <= 1'b0;
          pop <= 1'b0;
        end
      8'b0110xxxx:  // Alu (~a)
        begin
          op_alu <= 3'b001;
          s_inc <= 1'b1;
          we3 <= 1'b1;
          wez <= 1'b1;
          s_inm <= 1'b1;
          s_rel_pc <= 1'b0;
          s_pila <= 1'b0;
          push <= 1'b0;
          pop <= 1'b0;
        end
      8'b0111xxxx:  // Alu (-a)
        begin    
          op_alu <= 3'b110; 
          s_inc <= 1'b1;
          we3 <= 1'b1;
          wez <= 1'b1;
          s_inm <= 1'b1;
          s_rel_pc <= 1'b0;
          s_pila <= 1'b0;
          push <= 1'b0;
          pop <= 1'b0;
      end
      8'b00010000: // Direccionamiento inmediato   opcode e inmediato (16 bits)
      begin
        
      end
      8'b00010001: // Direccionamiento directo     opcode y direccion de memoria (por el cable datos está el operando)  (16 bits)
      begin
        
      end
      8'b00010010: // Direccionamiento directo por registro   opcode y registro (4 bits)
      begin
        
      end
      8'b00010011: // Direccionamiento relativo   opcode y registro 24 bits 
      begin
        
      end
      8'b00010100: // salto absoluto 
      begin
        op_alu <= 3'b000;
        s_inm <= 1'b0;
        s_rel_pc <= 1'b0;
        s_inc <= 1'b0;
        we3 <= 1'b0;
        wez <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b0;
        pop <= 1'b0;
      end
      8'b00010101: // salto relativo a pc
      begin
        op_alu <= 3'b000;
        s_inm <= 1'b0;
        s_rel_pc <= 1'b1;
        s_inc <= 1'b1;
        we3 <= 1'b0;
        wez <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b0;
        pop <= 1'b0;
      end
      8'b00010110: // salto jz
      begin
        op_alu <= 3'b000;
        s_inm <= 1'b0;
        s_rel_pc <= 1'b0;
        s_inc <= z ? 1'b0 : 1'b1;
        we3 <= 1'b0;
        wez <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b0;
        pop <= 1'b0;
      end
      8'b00010111: // salto jnz
      begin 
        op_alu <= 3'b000;
        s_inm <= 1'b0;
        s_rel_pc <= 1'b0;
        s_inc <= z ? 1'b1 : 1'b0;
        we3 <= 1'b0;
        wez <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b0;
        pop <= 1'b0;
      end
      8'b00011000: // call subrutina con salto relativo
      begin
        op_alu <= 3'b000;
        s_inm <= 1'b0;
        s_rel_pc <= 1'b1;
        s_inc <= 1'b1;  // si es 0 es salto absoluto
        we3 <= 1'b0;
        wez <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b1;
        pop <= 1'b0;
      end
      8'b00011001: // ret subrutina
      begin
        op_alu <= 3'b000;
        s_inm <= 1'b0;
        s_rel_pc <= 1'b0;
        s_inc <= 1'b0;
        we3 <= 1'b0;
        wez <= 1'b0;
        s_pila <= 1'b1;
        push <= 1'b0;
        pop <= 1'b1;
      end
      8'b00011111:  // nop
      begin
        op_alu <= 3'b000;
        s_inm <= 1'b0;
        s_rel_pc <= 1'b0;
        s_inc <= 1'b1;
        we3 <= 1'b0;
        wez <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b0;
        pop <= 1'b0;        
      end
      default:
      begin
        op_alu <= 3'b000;
        s_inc <= 1'b0;
        we3 <= 1'b0;
        wez <= 1'b0;
        s_inm <= 1'b0;
        s_datos <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b0;
        pop <= 1'b0;
      end
    endcase
    casex (interrupcion)
      8'bxxxxxxx1:
      begin
        op_alu <= 3'b000;
        s_inm <= 1'b0;
        s_rel_pc <= 1'b1;
        s_inc <= 1'b1; // esto tiene que cambiar a una dirección concreta, pondré un mux 1 a 4
        we3 <= 1'b0;
        wez <= 1'b0;
        s_pila <= 1'b0;
        push <= 1'b1;
        pop <= 1'b0;       
      end  // 
      8'bxxxxxx10:
      8'bxxxxx100:
      8'bxxxx1000:
      8'bxxx10000:
      8'bxx100000:
      8'bx1000000:
      8'b10000000:
    endcase
  end

endmodule