`timescale 1 ns / 10 ps

module cu(input wire [7:0] opcode, 
          input wire z, c, overflow, 
          input wire [7:0] min_bit_s, min_bit_a, 
          output wire s_rel, s_inm, s_stack, s_data, we3, wez, push, pop, oe,
          output wire [1:0] s_inc,
          output wire [2:0] op_alu, 
          output wire [7:0] s_calli, s_reti);

  parameter NEW_INTER   = 31'b00000010010; // De s_calli a op_alu son 0
  parameter ALU_R       = 31'b00001100000;
  parameter ALU_I       = 31'b01001100000;
  parameter LOAD        = 31'b01011000000;   // no probado
  parameter LOADR       = 31'b01011000000;  // no probado
  parameter STORE       = 31'b01000000100;  // no probado
  parameter STORER      = 31'b01000000100;  // no codificado
  parameter AB_JUMP     = 31'b00000000001;
  parameter REL_JUMP    = 31'b10000000000;
  parameter NOP         = 31'b00000000000;
  parameter CALL        = 31'b10000010000;
  parameter RETURN      = 31'b00100001000;

  reg [30:0] control;

  assign {s_calli, s_reti, op_alu, s_rel, s_inm, s_stack, s_data, we3, wez, push, pop, oe, s_inc} = control;

  always @(opcode, min_bit_a) 
  begin
    if (overflow)
    begin
      control = NEW_INTER;
      control[30:23] = 8'b00000001; // calli
    end
    else if((min_bit_s != 0 && min_bit_a == 0) || min_bit_s < min_bit_a)
    begin
      control = NEW_INTER;
      control[30:23] = min_bit_s; // calli
    end
    else
      casex (opcode)
        8'b1xxxxxxx: // aritmetico-lógico registros
        begin
          control = ALU_R;
          control[14:12] = opcode[6:4]; // op_alu
        end
        8'b0xxxxxxx: 
        begin
          if (opcode[6:4] != 3'b001)
            casex (opcode[6:4])
              3'b000: control = STORE;
              3'b010: control = STORER;
              3'b011: control = LOAD;
              3'b100: control = LOADR;
              3'b101: control = CALL;
              3'b110: control = RETURN;
              default: control = NOP;
          endcase
          else
            casex (opcode)
              8'b00010xxx:
              begin
                control = ALU_I;
                control[14:12] = opcode[2:0]; // op_alu
              end
              8'b00011000: control = AB_JUMP;
              8'b00011001: control = REL_JUMP;
              8'b00011010: control = z ? REL_JUMP : NOP;  // jz
              8'b00011011: control = z ? NOP : REL_JUMP;  // jnz
              8'b00011100: control = c ? REL_JUMP : NOP;  // jne
              8'b00011101: // reti interrupcion
              begin
                control = RETURN;
                control[22:15] = min_bit_a; // s_reti
              end
              default: control = NOP;
          endcase
        end
        default: control = NOP;
      endcase
  end
endmodule