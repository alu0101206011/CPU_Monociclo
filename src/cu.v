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
  parameter LOAD = 11'b01011100100;   // no probado
  parameter LOADR = 11'b01011100100;  // no probado
  parameter STORE = 11'b01010000100;  // no probado
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
          if (opcode[6:4] != 3'b001)  // aritmetico-lógico inmediato
          begin
            op_alu <= opcode[6:4];
            control <= ALU_I;
          end
          else
            casex (opcode)
              8'bxxxx0000: control <= LOAD;
              8'bxxxx0001: control <= LOADR;
              8'bxxxx0010: control <= STORE;
              8'bxxxx0011: control <= AB_JUMP;
              8'bxxxx0100: control <= REL_JUMP;
              8'bxxxx0101: control <= z ? AB_JUMP : NOP; // jz
              8'bxxxx0110: control <= z ? NOP : AB_JUMP; // jnz
              8'bxxxx0111: control <= c ? AB_JUMP : NOP; // jne
              8'bxxxx1000: control <= CALL;
              8'bxxxx1001: control <= RETURN;  
              8'bxxxx1010: // reti interrupcion
              begin
                control <= RETURN;
                s_reti <= min_bit_a;
                s_calli <= 8'b0;
              end
              8'bxxxx1111: control <= NOP;
              default: control <= NOP;
          endcase
        end
        default: control <= NOP;
      endcase
  end
endmodule