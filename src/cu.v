`timescale 1 ns / 10 ps

module cu(input wire [7:0] opcode, 
          input wire z, c, overflow, 
          input wire [7:0] min_bit_s, min_bit_a, 
          output wire s_jrel_pc, s_inm, s_stack, s_data, we3, wez, push, pop, oe,
          output wire [1:0] s_inc,
          output reg [2:0] op_alu, 
          output reg [7:0] s_calli, s_reti);

  parameter NEW_INTER = 11'b00000010010;
  parameter ALU_R = 11'b00001100000;
  parameter ALU_I = 11'b01001100000;
  parameter LOAD = 11'b01011000000;   // no probado
  parameter LOADR = 11'b01011000000;  // no probado
  parameter STORE = 11'b01000000100;  // no probado
  parameter STORER = 11'b01000000100;  // no codificado
  parameter AB_JUMP = 11'b00000000001;
  parameter REL_JUMP = 11'b10000000000;
  parameter NOP = 11'b00000000000;
  parameter CALL = 11'b10000010000;
  parameter RETURN = 11'b00100001000;

  reg [10:0] control;

  assign {s_jrel_pc, s_inm, s_stack, s_data, we3, wez, push, pop, oe, s_inc} = control;

  initial
  begin
    s_calli = 8'b0;
    s_reti = 8'b0;
  end

  always @(opcode, min_bit_a) 
  begin
    if (overflow)
    begin
      s_reti <= 8'b0;
      s_calli <= 8'b00000001;
      control <= NEW_INTER;
    end
    else if((min_bit_s != 0 && min_bit_a == 0) || min_bit_s < min_bit_a)
    begin
      s_reti <= 8'b0;
      s_calli <= min_bit_s;
      control <= NEW_INTER;
    end
    else
      casex (opcode)
        8'b1xxxxxxx: // aritmetico-lógico registros
        begin
          op_alu <= opcode[6:4];
          control <= ALU_R;
        end
        8'b0xxxxxxx: 
        begin
          if (opcode[6:4] != 3'b001)
            casex (opcode[6:4])
              3'b000: control <= STORE;
              3'b010: control <= STORER;
              3'b011: control <= LOAD;
              3'b100: control <= LOADR;
              3'b101: control <= CALL;
              3'b110: control <= RETURN;
              default: control <= NOP;
          endcase
          else
            casex (opcode)
              8'b00010xxx:
              begin
                op_alu <= opcode[2:0];
                control <= ALU_I;
              end
              8'b00011000: control <= AB_JUMP;
              8'b00011001: control <= REL_JUMP;
              8'b00011010: control <= z ? REL_JUMP : NOP;  // jz
              8'b00011011: control <= z ? NOP : REL_JUMP;  // jnz
              8'b00011100: control <= c ? REL_JUMP : NOP;  // jne
              8'b00011101: // reti interrupcion
              begin
                control <= RETURN;
                s_reti <= min_bit_a;
                s_calli <= 8'b0;
              end
              default: control <= NOP;
          endcase
        end
        default: control <= NOP;
      endcase
  end
endmodule