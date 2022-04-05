`timescale 1 ns / 10 ps

module cpu_tb;


reg clk, reset;
wire [15:0] datos, direcciones, leds;
reg [15:0] botones;
wire ce;
wire [7:0] interrupcion;
integer idx;

// generación de reloj clk
always //siempre activo, no hay condición de activación
begin
  clk = 1'b1;
  #30;
  clk = 1'b0;
  #30;
end

// instancia entrada salida
e_s entada_salida(clk, reset, direcciones, botones, datos, ce, leds);

// instancia del procesador
cpu cpumono(clk, reset, datos, interrupcion, direcciones);

// timer
timer contador(clk, reset, 8'd7, interrupcion);

initial
begin
  $dumpfile("./bin/cpu_tb.vcd");
  $dumpvars;
  for (idx = 0; idx < 16; idx = idx + 1) $dumpvars(0,cpu_tb.cpumono.camino_datos.banco_registros.regb[idx]);  
  for (idx = 0; idx < 16; idx = idx + 1) $dumpvars(0,cpu_tb.cpumono.camino_datos.stack.mempila[idx]);

  reset = 1;  //a partir del flanco de subida del reset empieza el funcionamiento normal
  #10;
  reset = 0;  //bajamos el reset 

  #30
  botones = 16'b1;
  #10
  botones = 16'b0;

end

reg signed [15:0] registros;

initial
begin
  #(120*60);  //Esperamos 12 ciclos o 12 instrucciones
  for (idx = 0; idx < 16; idx = idx + 1)
  begin
    registros[15:0] = cpu_tb.cpumono.camino_datos.banco_registros.regb[idx];
    $write("R%d = %d\n",idx, registros);
  end
  $finish;
end

endmodule
