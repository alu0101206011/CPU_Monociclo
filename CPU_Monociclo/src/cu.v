`timescale 1 ns / 10 ps

module cu(input wire [7:0] opcode, 
          input wire z, c, overflow_ALU, overflow_Stack,
          input wire [7:0] min_bit_s, min_bit_a, int_a,
          output wire s_rel, s_inm, s_stack, s_data, we3, wez, push, pop, oe,
          output wire [1:0] s_inc,
          output wire [2:0] op_alu, 
          output wire [7:0] s_calli, s_reti);

  wire [13:0] control, controlOP, controlIN;

  assign {s_rel, s_inm, s_stack, s_data, we3, wez, push, pop, oe, s_inc, op_alu} = control;

  wire stop_opcode, reti_on;
  assign stop_opcode = overflow_ALU | overflow_Stack | ((min_bit_s != 0 && min_bit_a == 0) || min_bit_s < min_bit_a);

  opcode_cu opcodeCU(opcode, ~stop_opcode, z, c, controlOP, reti_on);
  inter_cu interCU(min_bit_s, min_bit_a, overflow_ALU, overflow_Stack, reti_on, s_calli, s_reti, controlIN);

  assign control = controlOP | controlIN;
endmodule


module inter_cu(input wire [7:0] min_bit_s, min_bit_a, input wire overflow_ALU, overflow_Stack, reti_on, output reg [7:0] s_calli, s_reti, output reg [13:0] control);
  parameter NEW_INTER = 14'b00000010010000;
  parameter RETURN = 14'b00100001000000;

  always @(min_bit_a or min_bit_s or overflow_ALU or overflow_Stack or reti_on)
  begin
    if (overflow_ALU)
    begin
      s_reti <= 8'b0;
      s_calli <= 8'b1;
      control <= NEW_INTER;
    end
    else if (overflow_Stack)
    begin
      s_reti <= 8'b0;
      s_calli <= 8'b10;
      control <= NEW_INTER;
    end
    else if((min_bit_s != 0 && min_bit_a == 0) || min_bit_s < min_bit_a)
    begin
      s_reti <= 8'b0;
      s_calli <= min_bit_s;
      control <= NEW_INTER;
    end
    else if (reti_on)
    begin
      s_calli <= 8'b0;
      s_reti <= min_bit_a; 
      control <= 14'b0;
    end
    else 
    begin
      s_calli <= 8'b0;
      s_reti <= 8'b0;
      control <= 14'b0;      
    end
  end
endmodule

module opcode_cu(input wire [7:0] opcode, input wire we, z, c, output wire [13:0] control, output wire reti_on);
  parameter ALU_R = 15'b000011000000000;
  parameter ALU_I = 15'b010011000000000;
  parameter LOAD = 15'b010110000000000;
  parameter LOADR = 15'b010110000000000;
  parameter STORE = 15'b010000001000000;
  parameter STORER = 15'b010000001000000;
  parameter AB_JUMP = 15'b000000000010000;
  parameter REL_JUMP = 15'b100000000000000;
  parameter NOP = 15'b000000000000000;
  parameter CALL = 15'b100000100000000;
  parameter RETURN = 15'b001000010000000;

  reg [14:0] control2;

  assign {control, reti_on} = control2;

  always @(opcode or we or z or c)
  begin
    if (!we)
      control2 <= NOP;
    else if (opcode[7] == 1'b1)
    begin
      control2 = ALU_R;
      control2[3:1] = opcode[6:4];
    end
    else if (opcode[6:4] != 3'b001) // opcode[7] == 0
      casex (opcode[6:4])
        3'b000: control2 <= STORE;
        3'b010: 
        begin
          control2 = STORER;
          control2[3:1] = 3'b010; // suma
        end
        3'b011: control2 <= LOAD;
        3'b100: 
        begin
          control2 = LOADR;
          control2[3:1] = 3'b010; // suma
        end
        3'b101: control2 <= CALL;
        3'b110: control2 <= RETURN;
        default: control2 <= NOP;
      endcase
    else
      casex (opcode)
        8'b00010xxx:
        begin
          control2 = ALU_I;
          control2[3:1] = opcode[2:0];
        end
        8'b00011000: control2 <= AB_JUMP;
        8'b00011001: control2 <= REL_JUMP;
        8'b00011010: control2 <= z ? REL_JUMP : NOP;  // jz
        8'b00011011: control2 <= z ? NOP : REL_JUMP;  // jnz
        8'b00011100: control2 <= c ? REL_JUMP : NOP;  // jne
        8'b00011101: 
        begin
          control2 = RETURN;
          control2[0] = 1'b1;
        end
        default: control2 <= NOP;
      endcase
  end
endmodule