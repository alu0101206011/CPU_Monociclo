`timescale 1 ns / 10 ps

module uc(input wire [7:0] opcode, 
          input wire z, uflow, oflow, 
          input wire [7:0] data_s, int_a, 
          output reg s_rel_pc, s_inm, s_pila, s_datos, we3, wez, push, pop, oe, // añadir oe
          output reg [1:0] s_inc,
          output reg [2:0] op_alu, 
          output reg [7:0] s_calli, s_reti);

  wire [7:0] max_bit_s, max_bit_a;
  max_bit Interrupcion_s(data_s, max_bit_s);
  max_bit Interrupcion_a(int_a, max_bit_a);
  
  initial
  begin
    op_alu <= 3'b000; 
    s_inc <= 2'b00;
    we3 <= 1'b0;
    wez <= 1'b0;         
    s_inm <= 1'b0; 
    s_datos <= 1'b0;
    s_rel_pc <= 1'b0;
    s_pila <= 1'b0;
    push <= 1'b0;
    pop <= 1'b0;
    s_calli <= 8'b0;
    s_reti <= 8'b0;
    oe <= 1'b0;
  end

  always @(opcode, max_bit_a)
  begin
    if(max_bit_s > max_bit_a)
    begin
      s_reti <= 8'b0;
      s_calli <= max_bit_s;
      op_alu <= 3'b000; 
      s_inc <= 2'b10;
      we3 <= 1'b0;
      wez <= 1'b0;         
      s_inm <= 1'b0; 
      s_datos <= 1'b0;
      s_rel_pc <= 1'b0;
      s_pila <= 1'b0;
      push <= 1'b1;
      pop <= 1'b0;
    end
    if (max_bit_s == max_bit_a)
      casex (opcode)
        8'b1xxxxxxx: // aritmetico-lógico registros
        begin
          op_alu <= opcode[6:4];
          s_inm <= 1'b0;
          s_inc <= 2'b00;
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
          s_inc <= 2'b00;
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
            s_inc <= 2'b00;
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
            s_inc <= 2'b00;
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
            s_inc <= 2'b00;
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
            s_inc <= 2'b00;
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
            s_inc <= 2'b00;
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
            s_inc <= 2'b00;
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
          s_inc <= 2'b01;
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
          s_inc <= 2'b00;
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
          s_inc <= z ? 2'b01 : 2'b00;
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
          s_inc <= z ? 2'b00 : 2'b01;
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
          s_inc <= 2'b00;
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
          s_inc <= 2'b00;  // da un poco igual
          we3 <= 1'b0;
          wez <= 1'b0;
          s_pila <= 1'b1;
          push <= 1'b0;
          pop <= 1'b1;
        end
        8'b00011010:  // reti interrupcion
        begin
          op_alu <= 3'b000;
          s_inm <= 1'b0;
          s_rel_pc <= 1'b0;
          s_inc <= 2'b00;  // da un poco igual
          we3 <= 1'b0;
          wez <= 1'b0;
          s_pila <= 1'b1;
          push <= 1'b0;
          pop <= 1'b1;
          s_reti <= max_bit_a;
          s_calli <= 8'b0;
        end
        8'b00011111:  // nop
        begin
          op_alu <= 3'b000;
          s_inm <= 1'b0;
          s_rel_pc <= 1'b0;
          s_inc <= 2'b00;
          we3 <= 1'b0;
          wez <= 1'b0;
          s_pila <= 1'b0;
          push <= 1'b0;
          pop <= 1'b0;        
        end
        default:
        begin
          op_alu <= 3'b000;
          s_inc <= 2'b00;
          we3 <= 1'b0;
          wez <= 1'b0;
          s_inm <= 1'b0;
          s_datos <= 1'b0;
          s_pila <= 1'b0;
          push <= 1'b0;
          pop <= 1'b0;
        end
      endcase
    // hacer un return especial porque hace un par de cosas
    // 2 registros  Solicitud  Atencion

    // 8 lineas de interrupcion del exterior
    // Solicitud baja cuando quiere
    // Returni
    // s_returni de 3 bits o de 8
    // hacemos una caja en la que haya un we entre un s_reti
    // que hay que poner dentro de la caja? en la caja enetran
    // 

  end

  // nos acaban de decir de hacer una memoria nueva

  

endmodule