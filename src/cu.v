`timescale 1 ns / 10 ps

module cu(input wire [7:0] opcode, 
          input wire z, c, overflow_ALU, overflow_Stack,
          input wire [7:0] min_bit_s, min_bit_a, 
          output wire s_rel, s_inm, s_stack, s_data, we3, wez, push, pop, oe,
          output wire [1:0] s_inc,
          output reg [2:0] op_alu, 
          output reg [7:0] s_calli, s_reti);

  parameter NEW_INTER = 11'b00000010010;
  parameter ERROR_INTER = 11'b00000110010;
  parameter ALU_R = 11'b00001100000;
  parameter ALU_I = 11'b01001100000;
  parameter LOAD = 11'b01011000000;
  parameter LOADR = 11'b01011000000;
  parameter STORE = 11'b01000000100;
  parameter STORER = 11'b01000000100;
  parameter AB_JUMP = 11'b00000000001;
  parameter REL_JUMP = 11'b10000000000;
  parameter NOP = 11'b00000000000;
  parameter CALL = 11'b10000010000;
  parameter RETURN = 11'b00100001000;

  reg [10:0] control;

  assign {s_rel, s_inm, s_stack, s_data, we3, wez, push, pop, oe, s_inc} = control;

  always @(opcode, min_bit_a) 
  begin
    if (overflow_ALU)
    begin
      s_reti <= 8'b0;
      s_calli <= 8'b1;
      op_alu <= 3'b0;
      control <= NEW_INTER;
    end
    else if (overflow_Stack)
    begin
      s_reti <= 8'b0;
      s_calli <= 8'b10;
      op_alu <= 3'b0;
      control <= NEW_INTER;
    end
    else if((min_bit_s != 0 && min_bit_a == 0) || min_bit_s < min_bit_a)
    begin
      s_reti <= 8'b0;
      s_calli <= min_bit_s;
      op_alu <= 3'b0;
      control <= NEW_INTER;
    end
    else
      casex (opcode)
        8'b1xxxxxxx: // aritmetico-lógico registros
        begin
          op_alu <= opcode[6:4];
          s_calli <= 8'b0;
          s_reti <= 8'b0;
          control <= ALU_R;
        end
        8'b0xxxxxxx: 
        begin
          if (opcode[6:4] != 3'b001)
            casex (opcode[6:4])
              3'b000: 
              begin
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= STORE;
              end
              3'b010: 
              begin
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= STORER;
              end
              3'b011: 
              begin
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= LOAD;
              end
              3'b100: 
              begin
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= LOADR;
              end
              3'b101: 
              begin
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= CALL;
              end
              3'b110: 
              begin
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= RETURN;
              end
              default: 
              begin
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= NOP;
              end
          endcase
          else
            casex (opcode)
              8'b00010xxx:
              begin
                op_alu <= opcode[2:0];
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= ALU_I;
              end
              8'b00011000: 
              begin  
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= AB_JUMP;
              end
              8'b00011001: 
              begin  
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= REL_JUMP;
              end
              8'b00011010: 
              begin  
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= z ? REL_JUMP : NOP;  // jz
              end
              8'b00011011: 
              begin  
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= z ? NOP : REL_JUMP;  // jnz
              end
              8'b00011100: 
              begin  
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= c ? REL_JUMP : NOP;  // jne
              end
              8'b00011101: // reti interrupcion
              begin
                op_alu <= 3'b0;
                control <= RETURN;
                s_reti <= min_bit_a;
                s_calli <= 8'b0;
              end
              default:
              begin
                op_alu <= 3'b0;
                s_calli <= 8'b0;
                s_reti <= 8'b0;
                control <= NOP;
              end
          endcase
        end
        default: 
        begin
          op_alu <= 3'b0;
          s_calli <= 8'b0;
          s_reti <= 8'b0;
          control <= NOP;
        end
      endcase
  end
endmodule