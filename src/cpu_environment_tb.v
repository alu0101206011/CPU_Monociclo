`timescale 1 ns / 10 ps

module cpu_tb;


reg clk, reset;
wire [15:0] data;
wire [17:0] addresses;
wire [9:0] led_r, switches;
reg [3:0] buttons;
wire [7:0] led_g;
wire [4:0] control_mem;
wire oe;
integer idx;

cpu_environment datalogger(clk, reset, switches, buttons, led_r, led_g, addresses, control_mem, data); 

// generación de reloj clk
always //siempre activo, no hay condición de activación
begin
  clk = 1'b1;
  #30;
  clk = 1'b0;
  #30;
end


initial
begin
  $dumpfile("./bin/cpu_tb.vcd");
  $dumpvars;

  for (idx = 0; idx < 16; idx = idx + 1) $dumpvars(0,cpu_tb.datalogger.cpumono.data_path.register_file.regb[idx]);  
  for (idx = 0; idx < 16; idx = idx + 1) $dumpvars(0,cpu_tb.datalogger.cpumono.data_path.Stack.stackmem[idx]);

  reset = 1;  //a partir del flanco de subida del reset empieza el funcionamiento normal
  buttons = 16'b1;
  #10;
  reset = 0;  //bajamos el reset 

  
  #1000
  buttons = 16'b0;

  #200
  buttons = 16'b10;
  #70
  buttons = 16'b0;

end

reg signed [15:0] registers;

initial
begin
  #(120*1200);
  for (idx = 0; idx < 16; idx = idx + 1)
  begin
    registers[15:0] = cpu_tb.datalogger.cpumono.data_path.register_file.regb[idx];
    $write("R%d = %d\n",idx, registers);
  end
  $finish;
end

endmodule
